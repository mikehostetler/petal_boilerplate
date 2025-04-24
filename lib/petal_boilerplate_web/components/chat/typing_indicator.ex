defmodule PetalBoilerplateWeb.Components.Chat.TypingIndicator do
  use Phoenix.Component

  attr :sender, :string, default: nil
  attr :class, :string, default: nil
  attr :speed, :string, default: "normal", values: ~w(slow normal fast)

  def typing_indicator(assigns) do
    animation_class =
      case assigns.speed do
        "slow" -> "[animation-duration:1.5s]"
        "fast" -> "[animation-duration:0.5s]"
        _ -> "[animation-duration:1s]"
      end

    assigns = assign(assigns, :animation_class, animation_class)

    ~H"""
    <div class={["flex items-center p-4", @class]}>
      <div class="flex items-center space-x-2">
        <%= if @sender do %>
          <span class="text-sm text-gray-500 dark:text-gray-400"><%= @sender %> is typing</span>
        <% end %>
        <div class="flex space-x-1">
          <div class={["w-2 h-2 bg-gray-500 dark:bg-gray-400 rounded-full animate-bounce [animation-delay:-0.3s]", @animation_class]}></div>
          <div class={["w-2 h-2 bg-gray-500 dark:bg-gray-400 rounded-full animate-bounce [animation-delay:-0.15s]", @animation_class]}></div>
          <div class={["w-2 h-2 bg-gray-500 dark:bg-gray-400 rounded-full animate-bounce", @animation_class]}></div>
        </div>
      </div>
    </div>
    """
  end
end
