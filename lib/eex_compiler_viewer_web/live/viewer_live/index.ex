defmodule EexCompilerViewerWeb.ViewerLive.Index do
  use EexCompilerViewerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    buffer = Agent.start_link(fn -> [] end, name: :collector)

    {:ok,
     assign(socket,
       buffer: buffer,
       states: [],
       source: nil,
       engine: EEx.SmartEngine,
       user_assigns: %{}
     )}
  end

  @impl true
  def handle_event(
        "compile",
        %{"source" => %{"source" => source, "engine" => engine, "assigns" => user_assigns}},
        socket
      ) do
    EExCompiler.Compiler.compile(source, engine: e(engine))

    states = Enum.reverse(Agent.get(:collector, & &1))

    {:noreply,
     assign(socket,
       source: source,
       states: states,
       visible_state: 0,
       engine: engine,
       user_assigns: Code.eval_string(user_assigns) |> elem(0)
     )}
  end

  def handle_event("increment", _, socket) do
    {:noreply, assign(socket, visible_state: socket.assigns.visible_state + 1)}
  end

  def handle_event("decrement", _, socket) do
    {:noreply, assign(socket, visible_state: socket.assigns.visible_state - 1)}
  end

  defp e(engine), do: Module.concat([engine])

  defp r(engine, state) do
    ast =
      case state do
        {_, _, _} ->
          state

        _ ->
          e(engine).handle_body(state)
      end

    ast |> Macro.to_string() |> String.trim() |> Code.format_string!()
  rescue
    e ->
      Map.get(e, :description) || Map.get(e, :message)
  end

  defp eval(ast, assigns) do
    {res, _} = Code.eval_quoted(ast, assigns: assigns)

    case res do
      res when is_map(res) ->
        Phoenix.HTML.Engine.encode_to_iodata!(res)

      {:safe, res} ->
        res |> html_escape()

      res ->
        res |> html_escape()
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="two-cols">
      <div style="grid-column: span 1 / span 1;">
        <.form let={f} for={%Plug.Conn{}} as={:source} phx-submit="compile">
          <%= select f, :engine, ["EEx.SmartEngine", "Phoenix.HTML.Engine", "Phoenix.LiveView.Engine", "Phoenix.LiveView.HTMLEngine"], selected: @engine %>
          <%= text_input f, :assigns, value: inspect(@user_assigns) %>
          <%= textarea f, :source, placeholder: "Enter the source code", rows: 50, value: @source %>

          <%= submit "Compile" %>
        </.form>
        <%= if @source do %>
          <pre>
    <%= @source %>
          </pre>
        <% end %>
      </div>

      <div style="grid-column: span 1 / span 1;">
        <%= if not Enum.empty?(@states) do %>
          <div style="display: flex; justify-content: space-between">
            <button class={if(@visible_state == 0, do: "invisible")} phx-click="decrement"> Prev </button>
            <button class={if(@visible_state == length(@states) - 1, do: "invisible")} phx-click="increment"> Next </button>
          </div>
          <div class="bold">Engine: <%= @engine %></div>
          <div class="bold">Current State: <%= @visible_state + 1 %> </div>
          <div class="bold">Handler: <%= Enum.at(@states, @visible_state).name %> </div>
          <div class="bold">States: <%= length(@states) %> </div>
          <h2>Current Output</h2>
          <pre>
    <%= r(@engine, Enum.at(@states, @visible_state).buffer) %>
          </pre>

          <h2>Runtime Output</h2>
          <pre>
    <%= eval(List.last(@states).buffer, @user_assigns) %>
          </pre>
        <% end %>
      </div>
    </div>
    """
  end
end
