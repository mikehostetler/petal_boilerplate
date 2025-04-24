defmodule PetalBoilerplateWeb.ConversationLive do
  use PetalBoilerplateWeb, :live_view
  import PetalBoilerplateWeb.Components.Conversation.ConversationList

  def mount(_params, _session, socket) do
    # Sample conversations data
    conversations = [
      %{
        id: "1",
        title: "Roberta Casas",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Roberta",
        last_message: "Typing...",
        last_message_type: "text",
        last_message_at: "18:05",
        unread_count: 0,
        online: true
      },
      %{
        id: "2",
        title: "Leslie Livingston",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Leslie",
        last_message: "Yes, we can do this! 🔥",
        last_message_type: "text",
        last_message_at: "14:23",
        unread_count: 0,
        online: true
      },
      %{
        id: "3",
        title: "Neil Sims",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Neil",
        last_message: "Voice message",
        last_message_type: "voice",
        last_message_at: "10:02",
        unread_count: 4,
        online: false
      },
      %{
        id: "4",
        title: "Michael Gough",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Michael",
        last_message: "Nevermind, I will grab the ite...",
        last_message_type: "text",
        last_message_at: "07:45",
        unread_count: 0,
        online: true
      },
      %{
        id: "5",
        title: "Bonnie Green",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Bonnie",
        last_message: "Sent a photo",
        last_message_type: "photo",
        last_message_at: "15h",
        unread_count: 0,
        online: false
      },
      %{
        id: "6",
        title: "Lana Byrd",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Lana",
        last_message: "Awesome, let's go!",
        last_message_type: "text",
        last_message_at: "16h",
        unread_count: 0,
        online: false
      }
    ]

    {:ok,
     assign(socket,
       modal: false,
       slide_over: false,
       active_tab: :conversation,
       conversations: conversations,
       selected_conversation_id: nil,
       search_query: ""
     )}
  end

  def handle_event("select_conversation", %{"id" => id}, socket) do
    {:noreply, assign(socket, selected_conversation_id: id)}
  end

  def handle_event("search", %{"query" => query}, socket) do
    filtered_conversations =
      socket.assigns.conversations
      |> Enum.filter(fn conv ->
        String.contains?(
          String.downcase(conv.title),
          String.downcase(query)
        )
      end)

    {:noreply,
     assign(socket,
       search_query: query,
       filtered_conversations: filtered_conversations
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-md mx-auto bg-gray-900 shadow-xl rounded-lg overflow-hidden">
      <div class="flex items-center justify-between px-4 py-3 border-b border-gray-800">
        <h2 class="text-lg font-medium text-gray-100">Latest chats</h2>
        <div class="flex items-center gap-2">
          <button class="p-1.5 text-gray-400 hover:text-gray-300 rounded-lg hover:bg-gray-800">
            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
            </svg>
          </button>
          <button class="p-1.5 text-gray-400 hover:text-gray-300 rounded-lg hover:bg-gray-800">
            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
          </button>
        </div>
      </div>

      <.conversation_list
        conversations={@conversations}
        selected_id={@selected_conversation_id}
        search_query={@search_query}
        class="h-[600px] overflow-y-auto"
      />
    </div>
    """
  end
end
