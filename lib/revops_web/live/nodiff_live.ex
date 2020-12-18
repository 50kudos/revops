defmodule RevopsWeb.NodiffLive do
  use RevopsWeb, :live_view

  defp get(socket), do: socket.private[:state]
  defp put(socket, v), do: put_in(socket.private[:state], v)
  defp update(socket, f), do: update_in(socket.private[:state], f)

  def mount(_, _, socket), do: {:ok, put(socket, %{count: 0, items: [0, 1, 2, 3, 4]})}

  def render(assigns),
    do: ~L"<main id='main-hook' phx-hook='main'><%= eex(get(@socket)) %><main>"

  defp eex(assigns) do
    ~E"""
    <ul>
      <%= for n <- @items do %>
        <li>item <%= n %> <span phx-click="del" phx-value-item_id="<%= n %>">&times</span></li>
      <% end %>
    </ul>
    <button phx-click="inc">+</button>
    <span data-target="count"><%= @count %></span>
    <button phx-click="dec">-</button>
    """
  end

  def handle_event(event, _value, socket) when event in ~w(inc dec) do
    socket =
      case event do
        "inc" -> update(socket, &%{&1 | count: &1.count + 1})
        "dec" -> update(socket, &%{&1 | count: &1.count - 1})
      end

    cmd = %{selector: "[data-target='count']", ops: %{replace: "#{get(socket).count}"}}
    {:noreply, push_event(socket, :update, cmd)}
  end

  def handle_event("del", value, socket) do
    item_id = Map.get(value, "item_id")

    update(socket, fn state ->
      %{state | items: List.delete_at(state.items, String.to_integer(item_id))}
    end)

    cmd = %{selector: "li span[phx-value-item_id='#{item_id}']", ops: :remove}
    {:noreply, push_event(socket, :update, cmd)}
  end
end
