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
    Postgrex.query!(DB, "DROP TABLE IF EXISTS grupper", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS skolor", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS elever", [], pool: DBConnection.ConnectionPool)
  end

  defp create_tables() do
    IO.puts("Creating tables")
    Postgrex.query!(DB, "Create TABLE Users (id SERIAL, name VARCHAR(255) NOT NULL, type VARCHAR(255) NOT NULL, password_hash VARCHAR(255))", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE Skolor (id SERIAL, name VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE Grupper (id SERIAL, name VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "Create TABLE Elever (id SERIAL, name VARCHAR(255) NOT NULL, grupp VARCHAR(255) NOT NULL)", [], pool: DBConnection.ConnectionPool)
  end

  defp seed_data() do
    IO.puts("Seeding data")
    Postgrex.query!(DB, "INSERT INTO Users(name, type, password_hash) VALUES($1, $2, $3)", ["Admin", "Admin", Tuple.to_list(Map.fetch(Bcrypt.add_hash("qwert123"), :password_hash)) |> Enum.at(1)], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Users(name, type, password_hash) VALUES($1, $2, $3)",["Lärare", "Lärare", Tuple.to_list(Map.fetch(Bcrypt.add_hash("asd123"), :password_hash)) |> Enum.at(1)], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Skolor(name) VALUES($1)",["Nti Gymnasiet"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Skolor(name) VALUES($1)",["WisbyGymnasiet"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO GRUPPER(name) VALUES($1)",["TE4"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO GRUPPER(name) VALUES($1)",["TE3"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Elever(name, grupp) VALUES($1, $2)",["Jonathan", "TE4"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Elever(name, grupp) VALUES($1, $2)",["Mahdi", "TE4"], pool: DBConnection.ConnectionPool)
    Postgrex.query!(DB, "INSERT INTO Elever(name, grupp) VALUES($1, $2)",["Jacob", "TE3"], pool: DBConnection.ConnectionPool)
  end

end
