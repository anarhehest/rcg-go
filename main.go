package main

import (
	"html/template"
	"log"
	"net/http"
)

func main() {
	// Настройка логирования
	log.SetPrefix("[HTTP] ")
	log.SetFlags(log.Ldate | log.Ltime | log.Lmicroseconds)

	// Обработка статических файлов
	http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("./static"))))

	// Парсинг шаблона
	tmpl := template.Must(template.ParseFiles("templates/index.html"))

	// Обработчик корневого маршрута
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Обработка запроса: %s %s", r.Method, r.URL.Path)

		data := map[string]interface{}{
			"title": "Hello World",
			"body":  "Hello World!",
		}

		err := tmpl.Execute(w, data)
		if err != nil {
			log.Printf("Ошибка выполнения шаблона: %v", err)
			http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		}
	})

	// Запуск сервера на 0.0.0.0:8080
	log.Printf("Запуск сервера на 0.0.0.0:8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatalf("Ошибка запуска сервера: %v", err)
	}
}
