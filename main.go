package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"github.com/rs/cors"
)

var db *gorm.DB
var err error

type Result struct {
	Data    interface{} `json:"data"`
	Message string      `json:"message"`
}

type User struct {
	ID       int    `json:"id" gorm:"primaryKey"`
	Nama     string `json:"nama"`
	Password string `json:"password"`
	No_wa    string `json:"no_wa"`
}

func main() {
	db, err = gorm.Open("mysql", "root:@/db_login?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		log.Println("Connection failed", err)
	} else {
		log.Println("Connection established")
	}

	db.AutoMigrate(&User{})
	handleRequests()
}

func handleRequests() {
	log.Println("Start the development server at http://127.0.0.1:8080")

	myRouter := mux.NewRouter().StrictSlash(true)

	myRouter.HandleFunc("/", homePage)
	myRouter.HandleFunc("/api/user", createUser).Methods("POST")
	myRouter.HandleFunc("/api/user", getUser).Methods("GET")
	myRouter.HandleFunc("/api/login", loginUser).Methods("POST")

	handler := cors.Default().Handler(myRouter)
	http.ListenAndServe(":8080", handler)
}

func homePage(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Welcome!")
}

func createUser(w http.ResponseWriter, r *http.Request) {
	payloads, _ := ioutil.ReadAll(r.Body)

	var user User
	if err := json.Unmarshal(payloads, &user); err != nil {
		log.Println("Error unmarshalling JSON:", err)
		http.Error(w, "Failed to process JSON payload", http.StatusBadRequest)
		return
	}

	if err := db.Create(&user).Error; err != nil {
		log.Println("Error creating User:", err)
		http.Error(w, "Failed to create User", http.StatusInternalServerError)
		return
	}

	res := Result{Data: user, Message: "Success create data User"}
	result, err := json.Marshal(res)
	if err != nil {
		log.Println("Error marshalling JSON:", err)
		http.Error(w, "Failed to process response", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(result)
}

func getUser(w http.ResponseWriter, r *http.Request) {
	users := []User{}

	db.Find(&users)

	res := Result{Data: users, Message: "Succes get data User"}
	results, err := json.Marshal(res)

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(results)
}

func loginUser(w http.ResponseWriter, r *http.Request) {
	payloads, _ := ioutil.ReadAll(r.Body)

	var user User
	if err := json.Unmarshal(payloads, &user); err != nil {
		log.Println("Error unmarshalling JSON:", err)
		http.Error(w, "Failed to process JSON payload", http.StatusBadRequest)
		return
	}

	db.Where("nama = ? AND password = ?", user.Nama, user.Password).First(&user)

	if user.ID == 0 {
		http.Error(w, "Invalid username or password", http.StatusUnauthorized)
		return
	}

	res := Result{Data: user, Message: "Success login"}
	result, err := json.Marshal(res)
	if err != nil {
		log.Println("Error marshalling JSON:", err)
		http.Error(w, "Failed to process response", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write(result)
}
