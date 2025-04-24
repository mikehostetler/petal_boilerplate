defmodule PetalBoilerplateWeb.Components.Conversation.ConversationList do
  use Phoenix.Component
  import PetalBoilerplateWeb.Components.Conversation.ConversationItem

  attr :conversations, :list, required: true, doc: "List of conversations to display"
  attr :selected_id, :string, default: nil, doc: "ID of the currently selected conversation"
  attr :search_query, :string, default: "", doc: "Current search query"

  attr :on_conversation_select, :string,
    default: "select_conversation",
    doc: "Event to emit when a conversation is selected"

  attr :class, :string, default: nil, doc: "Additional classes to apply to the list container"

  def conversation_list(assigns) do
    ~H"""
    <div>
      <div class="p-4">
        <div class="relative">
          <input
            type="text"
            placeholder="Search for messages or contacts"
            value={@search_query}
            phx-keyup="search"
            phx-key="*"
            class="w-full bg-gray-800 text-gray-100 text-sm rounded-lg pl-10 pr-4 py-2.5 border border-gray-700 focus:border-gray-600 focus:ring-0 placeholder-gray-500"
          />
          <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <svg class="w-5 h-5 text-gray-500" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>
        </div>
      </div>

      <div class={[
        "divide-y divide-gray-800/50",
        @class
      ]}>
        <%= for conversation <- @conversations do %>
          <.conversation_item
            conversation={conversation}
            selected?={conversation.id == @selected_id}
            on_select={@on_conversation_select}
          />
        <% end %>
        <%= if Enum.empty?(@conversations) do %>
          <div class="p-8 text-center">
            <div class="inline-flex items-center justify-center w-12 h-12 rounded-full bg-gray-800 mb-4">
              <svg class="w-6 h-6 text-gray-400" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
              </svg>
            </div>
            <p class="text-gray-400">No conversations yet</p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
