defmodule PetalBoilerplateWeb.ChatExampleLive do
  use PetalBoilerplateWeb, :live_view
  import PetalBoilerplateWeb.Components.Conversation.ConversationList
  import PetalBoilerplateWeb.Components.Chat.ChatMessage
  import PetalBoilerplateWeb.Components.Chat.ChatHeader
  import PetalBoilerplateWeb.Components.Chat.TypingIndicator
  alias PetalBoilerplateWeb.Components.Chat.ChatInput
  alias PetalBoilerplateWeb.ChatData

  def mount(_params, _session, socket) do
    conversations = ChatData.conversations()
    chat_history = ChatData.chat_history()

    {:ok,
     assign(socket,
       modal: false,
       slide_over: false,
       active_tab: :chat_example,
       conversations: conversations,
       selected_conversation_id: nil,
       chat_history: chat_history,
       show_typing: false,
       input_loading: false
     )}
  end

  def handle_event("select_conversation", %{"id" => id}, socket) do
    {:noreply, assign(socket, selected_conversation_id: id)}
  end

  def render(assigns) do
    ~H"""
    <div class="container mx-auto px-4 py-8">
      <div class="flex h-[800px] rounded-lg border border-gray-200 dark:border-gray-800">
        <%!-- Conversation List --%>
        <div class="w-1/3 border-r border-gray-200 dark:border-gray-800">
          <.conversation_list
            conversations={@conversations}
            selected_id={@selected_conversation_id}
            class="h-full overflow-y-auto"
          />
        </div>

        <%!-- Chat Area --%>
        <div class="w-2/3 flex flex-col">
          <%= if @selected_conversation_id do %>
            <% conversation = Enum.find(@conversations, &(&1.id == @selected_conversation_id)) %>
            <%!-- Chat Header --%>
            <.chat_header
              title={conversation.title}
              avatar_url={conversation.avatar_url}
              status={if @show_typing, do: "typing...", else: "online"}
            />

            <%!-- Messages Area --%>
            <div class="flex-1 overflow-y-auto p-4">
              <div class="flex flex-col space-y-4">
                <%= for message <- @chat_history[@selected_conversation_id] || [] do %>
                  <.chat_message
                    message={message.message}
                    sender={message.sender}
                    timestamp={message.timestamp}
                    is_self={message.is_self}
                  />
                <% end %>

                <%= if @show_typing do %>
                  <div class="p-4">
                    <.typing_indicator sender={conversation.title} speed="normal" />
                  </div>
                <% end %>
              </div>
            </div>

            <%!-- Chat Input --%>
            <div class="p-4 bg-gray-900 flex items-center gap-2">
              <div class="flex-1">
                <.live_component
                  module={ChatInput}
                  id="chat-input"
                  loading={@input_loading}
                  on_submit={&handle_message/1}
                  placeholder="Type your message..."
                />
              </div>
              <button
                type="submit"
                form="chat-input"
                disabled={@input_loading}
                class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Send
              </button>
            </div>
          <% else %>
            <div class="flex-1 flex items-center justify-center text-gray-500 dark:text-gray-400">
              <p>Select a conversation to start chatting</p>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def handle_message(message) do
    send(self(), {:new_message, message})
  end

  def handle_info({:new_message, message}, socket) when is_binary(message) do
    conversation_id = socket.assigns.selected_conversation_id
    conversation = Enum.find(socket.assigns.conversations, &(&1.id == conversation_id))

    # Add user's message
    socket = add_message(socket, message, "You", true)

    # Show typing indicator
    send(self(), :show_typing)
    # Schedule the response
    Process.send_after(self(), {:send_response, conversation}, 2000)

    {:noreply, assign(socket, input_loading: true)}
  end

  def handle_info({:new_message, _}, socket) do
    {:noreply, socket}
  end

  def handle_info(:show_typing, socket) do
    {:noreply, assign(socket, show_typing: true)}
  end

  def handle_info({:send_response, conversation}, socket) do
    responses = [
      "That's interesting! Tell me more.",
      "I understand what you mean.",
      "Thanks for sharing that!",
      "How fascinating!",
      "I hadn't thought about it that way before.",
      "Could you elaborate on that?",
      "That makes sense to me.",
      "I see your point."
    ]

    response = Enum.random(responses)

    socket =
      socket
      |> assign(show_typing: false, input_loading: false)
      |> add_message(response, conversation.title, false)
      |> update_conversation_last_message(response)

    {:noreply, socket}
  end

  defp add_message(socket, content, sender, is_self) do
    conversation_id = socket.assigns.selected_conversation_id

    new_message = %{
      message: content,
      sender: sender,
      timestamp: format_timestamp(DateTime.utc_now()),
      is_self: is_self
    }

    updated_history =
      Map.update(
        socket.assigns.chat_history,
        conversation_id,
        [new_message],
        &(&1 ++ [new_message])
      )

    assign(socket, chat_history: updated_history)
  end

  defp update_conversation_last_message(socket, message) do
    conversation_id = socket.assigns.selected_conversation_id

    updated_conversations =
      Enum.map(socket.assigns.conversations, fn conv ->
        if conv.id == conversation_id do
          %{conv | last_message: message, last_message_at: "just now"}
        else
          conv
        end
      end)

    assign(socket, conversations: updated_conversations)
  end

  defp format_timestamp(datetime) do
    datetime
    |> DateTime.to_time()
    |> Time.to_string()
    |> String.slice(0..4)
    |> Kernel.<>(if datetime.hour >= 12, do: "PM", else: "AM")
  end
end
