defmodule Pluggy.Template do
  def srender(file, data \\ [], layout \\ true) do
    {:ok, template} = File.read("templates/#{file}.slime")

    case layout do
      true ->
        {:ok, layout} = File.read("templates/layout.slime")
        # Makes the slim./2 function available in template files
        # thereby allowing for the use of partials
        data_function = [{:slime, fn(e, x) -> srender(e, x, false) end} | data]
        params = [{:template, Slime.render(template, data_function)} | data_function]
        # Render the layout file using params
        # params contains the :template, slim./2 function and the optionaly passed data
        Slime.Renderer.render(layout, params)

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
