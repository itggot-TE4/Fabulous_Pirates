defmodule Pluggy.Template do
  def srender(file, data \\ [], layout \\ true) do
    {:ok, template} = File.read("templates/#{file}.slime")

    case layout do
      true ->
        {:ok, layout} = File.read("templates/layout.slime")
        # Inserts data into template file
        temp = {:template, Slime.render(template, data)}
        # Inserts data into layout file
        Slime.Renderer.render(layout, [temp | data])

      false ->
        Slime.render(template, data)
    end
  end

  def render(file, data \\ [], layout \\ true) do
    case layout do
      true ->
        EEx.eval_file("templates/layout.eex",
          template: EEx.eval_file("templates/#{file}.eex", data)
        )

      false ->
        EEx.eval_file("templates/#{file}.eex", data)
    end
  end
end
