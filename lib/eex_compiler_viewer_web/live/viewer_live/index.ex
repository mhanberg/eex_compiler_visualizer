defmodule EexCompilerViewerWeb.ViewerLive.Index do
  use EexCompilerViewerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    buffer = Agent.start_link(fn -> [] end, name: :collector)
    {:ok, assign(socket, buffer: buffer, states: [], source: nil, engine: EEx.SmartEngine)}
  end

  @impl true
  def handle_event("compile", %{"source" => %{"source" => source, "engine" => engine}}, socket) do
    engine = Module.concat([engine])
    EExCompiler.Compiler.compile(source, engine: engine)

    states = Enum.reverse(Agent.get(:collector, & &1))

    {:noreply, assign(socket, source: source, states: states, visible_state: 0, engine: engine)}
  end

  def handle_event("increment", _, socket) do
    {:noreply, assign(socket, visible_state: socket.assigns.visible_state + 1)}
  end

  def handle_event("decrement", _, socket) do
    {:noreply, assign(socket, visible_state: socket.assigns.visible_state - 1)}
  end

  defp r(engine, state) do
    engine.handle_body(state) |> Macro.to_string() |> String.trim() |> Code.format_string!()
  rescue
    e ->
      e.description
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="two-cols">
      <div style="grid-column: span 1 / span 1;">
        <.form let={f} for={%Plug.Conn{}} as={:source} phx-submit="compile">
          <%= select f, :engine, ["EEx.SmartEngine", "Phoenix.HTML.Engine", "Phoenix.LiveView.Engine", "Phoenix.LiveView.HTMLEngine"] %>
          <%= textarea f, :source, placeholder: "Enter the source code", rows: 50 %>

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
          <div class="bold">States: <%= length(@states) %> </div>
          <h2>Current Output</h2>
          <pre>
    <%= r(@engine, Enum.at(@states, @visible_state)) %>
          </pre>
        <% end %>
      </div>
    </div>
    """
  end
end
