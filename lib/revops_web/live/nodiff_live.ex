defmodule RevopsWeb.NodiffLive do
  use RevopsWeb, :live_view

  defp get(socket), do: socket.private[:state]
  defp put(socket, v), do: put_in(socket.private[:state], v)
  defp update(socket, f), do: update_in(socket.private[:state], f)

  def mount(_, _, socket), do: {:ok, put(socket, %{count: 0, items: [0, 1, 2, 3, 4]})}

  def render(assigns),
    do: ~L"<main id='main-hook' phx-hook='stream'><%= eex(get(@socket)) %><main>"

  defp eex(assigns) do
    ~E"""
    <ul>
      <%= for n <- @items do %>
        <li id="<%= n %>">item <%= n %> <span phx-click="del" phx-value-item_id="<%= n %>">&times</span></li>
      <% end %>
    </ul>
    <button phx-click="inc">+</button>
    <%= count_component(%{count: @count}) %>
    <button phx-click="dec">-</button>
    """
  end

  defp count_component(assigns), do: ~E"<span id='count'><%= @count %></span>"

  def handle_event(event, _value, socket) when event in ~w(inc dec) do
    socket =
      case event do
        "inc" -> update(socket, &%{&1 | count: &1.count + 1})
        "dec" -> update(socket, &%{&1 | count: &1.count - 1})
      end

    data =
      ~E"""
      <turbo-stream action="replace" target="count">
        <template>
          <%= count_component(%{count: get(socket).count}) %>
        </template>
      </turbo-stream>
      """
      |> Phoenix.HTML.safe_to_string()

    {:noreply, push_event(socket, "phx-stream", %{data: data})}
  end

  def handle_event("del", value, socket) do
    item_id = Map.get(value, "item_id")

    socket =
      update(socket, fn state ->
        %{state | items: List.delete_at(state.items, String.to_integer(item_id))}
      end)

    data =
      ~E"""
      <turbo-stream action="remove" target="<%= item_id %>">
      </turbo-stream>
      """
      |> Phoenix.HTML.safe_to_string()

    {:noreply, push_event(socket, "phx-stream", %{data: data})}
  end
end
