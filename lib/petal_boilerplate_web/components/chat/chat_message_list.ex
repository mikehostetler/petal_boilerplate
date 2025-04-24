defmodule PetalBoilerplateWeb.Components.Chat.ChatMessageList do
  use Phoenix.Component
  use PetalComponents

  attr :messages, :list, required: true, doc: "List of chat messages to display"
  attr :current_user_id, :string, required: true, doc: "ID of the current user"

  def chat_message_list(assigns) do
    ~H"""
    <div class="flex flex-col space-y-4 p-4">
      <%= for message <- @messages do %>
        <div class={[
          "flex w-full",
          if(message.user_id == @current_user_id, do: "justify-end", else: "justify-start")
        ]}>
          <div class={[
            "max-w-[80%] rounded-lg p-3",
            if(message.user_id == @current_user_id, do: "bg-primary-100", else: "bg-gray-100")
          ]}>
            <p class="text-sm"><%= message.content %></p>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
