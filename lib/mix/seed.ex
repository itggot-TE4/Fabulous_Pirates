defmodule Mix.Tasks.Seed do
  use Mix.Task
  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run "app.start"
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS classes", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS schools", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS students", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS user_school_id", [], pool: DBConnection.ConnectionPool)
  end

  defp create_tables() do
    IO.puts("Creating tables")
    Postgrex.query!(DB, "Create TABLE Users (id SERIAL, name VARCHAR(255) NOT NULL, username VARCHAR(255) UNIQUE NOT NULL, type VARCHAR(255) NOT NULL, password_hash VARCHAR(255) NOT NULL, img VARCHAR(255))", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE Schools (id SERIAL, school_name VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE Classes (id SERIAL, class_name VARCHAR(255) NOT NULL, school_id INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE Students (id SERIAL, student_name VARCHAR(255) NOT NULL, class_id INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE User_School_id (id SERIAL, name_id INTEGER NOT NULL, school_id  INTEGER NOT NULL)", [], pool: DBConnection.ConnectionPool)
  end

  defp seed_data() do
    IO.puts("Seeding data")
    Postgrex.query!(DB, "INSERT INTO Users(name, username, type, password_hash) VALUES($1, $2, $3, $4)", ["Admin", "Admin", "Admin", Tuple.to_list(Map.fetch(Bcrypt.add_hash("qwert123"), :password_hash)) |> Enum.at(1)], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Users(name, username, type, password_hash) VALUES($1, $2, $3, $4)",["Daniel Berg", "daniel.berg", "Lärare", Tuple.to_list(Map.fetch(Bcrypt.add_hash("asd123"), :password_hash)) |> Enum.at(1)], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Schools(school_name) VALUES($1)",["Nti Gymnasiet"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Schools(school_name) VALUES($1)",["WisbyGymnasiet"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Classes(class_name, school_id) VALUES($1, $2)",["TE4", 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Classes(class_name, school_id) VALUES($1, $2)",["TE3", 2], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Students(student_name, class_id) VALUES($1, $2)",["Jonathan", 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Students(student_name, class_id) VALUES($1, $2)",["Mahdi", 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Students(student_name, class_id) VALUES($1, $2)",["Jacob", 2], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO User_School_id(name_id, school_id) VALUES($1, $2)",[2, 1], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO User_School_id(name_id, school_id) VALUES($1, $2)",[2, 2], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO User_School_id(name_id, school_id) VALUES($1, $2)",[3, 1], pool: DBConnection.ConnectionPool)
  end
end
