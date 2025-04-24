defmodule PetalBoilerplateWeb.Components.Conversation.ConversationItem do
  use Phoenix.Component
  import PetalComponents.Avatar

  attr :conversation, :map, required: true
  attr :selected?, :boolean, default: false
  attr :on_select, :string, default: "select_conversation"

  def conversation_item(assigns) do
    ~H"""
    <div
      class={[
        "flex items-center gap-3 px-4 py-3 cursor-pointer transition-colors",
        "hover:bg-gray-800/50",
        @selected? && "bg-gray-800/75"
      ]}
      phx-click={@on_select}
      phx-value-id={@conversation.id}
    >
      <div class="relative flex-shrink-0">
        <.avatar src={@conversation.avatar_url} size="sm" class="ring-2 ring-gray-800" />
        <%= if @conversation.online do %>
          <div class="absolute bottom-0 right-0 w-2.5 h-2.5 bg-emerald-500 border-2 border-gray-900 rounded-full"></div>
        <% end %>
      </div>

      <div class="flex-1 min-w-0">
        <div class="flex items-center justify-between">
          <p class="text-sm font-medium truncate text-gray-100">
            <%= @conversation.title %>
          </p>
          <span class="text-xs text-gray-500 min-w-[3rem] text-right">
            <%= @conversation.last_message_at %>
          </span>
        </div>
        <div class="flex items-center justify-between mt-0.5">
          <div class="flex items-center gap-1.5 max-w-[80%]">
            <%= if @conversation.last_message_type == "voice" do %>
              <svg class="w-3.5 h-3.5 text-gray-400 flex-shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11a7 7 0 01-7 7m0 0a7 7 0 01-7-7m7 7v4m0 0H8m4 0h4m-4-8a3 3 0 01-3-3V5a3 3 0 116 0v6a3 3 0 01-3 3z" />
              </svg>
            <% end %>
            <%= if @conversation.last_message_type == "photo" do %>
              <svg class="w-3.5 h-3.5 text-gray-400 flex-shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            <% end %>
            <p class="text-sm text-gray-400 truncate">
              <%= @conversation.last_message %>
            </p>
          </div>
          <%= if @conversation.unread_count > 0 do %>
            <span class="text-xs font-medium text-blue-400 ml-1.5">
              <%= @conversation.unread_count %>
            </span>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
