defmodule PetalBoilerplateWeb.ChatLive do
  use PetalBoilerplateWeb, :live_view
  import PetalBoilerplateWeb.Components.Chat.ChatMessage
  import PetalBoilerplateWeb.Components.Chat.ChatHeader
  import PetalBoilerplateWeb.Components.Chat.TypingIndicator
  import PetalBoilerplateWeb.Components.Chat.ChatStarter
  alias PetalBoilerplateWeb.Components.Chat.ChatInput
  require Logger

  @doc """
  Initial mount function that sets up the chat interface state
  """
  def mount(_params, _session, socket) do
    messages = [
      %{
        message: "Hey there! How's it going?",
        sender: "Alice",
        timestamp: format_timestamp(DateTime.utc_now()),
        is_self: false
      },
      %{
        message: "Hi Alice! I'm doing great, thanks for asking. How about you?",
        sender: "You",
        timestamp: format_timestamp(DateTime.utc_now()),
        is_self: true
      },
      %{
        message: "I'm doing well! Just working on some new features.",
        sender: "Alice",
        timestamp: format_timestamp(DateTime.utc_now()),
        is_self: false
      }
    ]

    group_participants = [
      %{name: "Alice Smith", avatar_url: "https://api.dicebear.com/7.x/identicon/svg?seed=alice"},
      %{name: "Bob Johnson", avatar_url: "https://api.dicebear.com/7.x/identicon/svg?seed=bob"},
      %{
        name: "Charlie Brown",
        avatar_url: "https://api.dicebear.com/7.x/identicon/svg?seed=charlie"
      },
      %{name: "Diana Prince", avatar_url: "https://api.dicebear.com/7.x/identicon/svg?seed=diana"}
    ]

    {:ok,
     assign(socket,
       modal: false,
       slide_over: false,
       group_size: "md",
       pagination_page: 1,
       total_pages: 10,
       active_tab: :chat,
       messages: messages,
       show_typing: false,
       input_loading: false,
       chat_started: false,
       ai_messages: [],
       group_participants: group_participants
     )}
  end

  def render(assigns) do
    ~H"""
    <.container class="mt-10 mb-32">
      <.h2 underline class="mt-10" label="AI Chat" />
      <div class="mb-10">
        <%= if !@chat_started do %>
          <.chat_starter loading={@input_loading} on_submit="start_chat" />
        <% else %>
          <div class="rounded-lg border border-gray-200 dark:border-gray-800">
            <.chat_header
              title="AI Assistant"
              avatar_url="https://api.dicebear.com/7.x/identicon/svg?seed=ai"
              status={if @show_typing, do: "typing...", else: "online"}
            />

            <div class="flex flex-col divide-y divide-gray-200 dark:divide-gray-800">
              <%= for message <- @ai_messages do %>
                <.chat_message
                  message={message.message}
                  sender={message.sender}
                  timestamp={message.timestamp}
                  is_self={message.is_self}
                />
              <% end %>

              <%= if @show_typing do %>
                <div class="p-4">
                  <.typing_indicator sender="AI" speed="normal" />
                </div>
              <% end %>
            </div>

            <.live_component
              module={ChatInput}
              id="chat-input"
              loading={@input_loading}
              on_submit={&handle_message/1}
              placeholder="Type your message here..."
            />
          </div>
        <% end %>
      </div>

      <.h2 underline class="mt-10" label="Chat Headers" />

      <div class="space-y-8">
        <div class="rounded-lg border border-gray-200 dark:border-gray-800">
          <.chat_header
            title="Alice Smith"
            avatar_url="https://api.dicebear.com/7.x/identicon/svg?seed=alice"
            status={if @show_typing, do: "typing...", else: "online"}
          />
        </div>

        <div class="rounded-lg border border-gray-200 dark:border-gray-800">
          <.chat_header
            title="Project Team"
            is_group={true}
            participants={@group_participants}
          />
        </div>

        <div class="rounded-lg border border-gray-200 dark:border-gray-800">
          <.chat_header
            title="Bob Johnson"
            avatar_url="https://api.dicebear.com/7.x/identicon/svg?seed=bob"
            status="online"
          />
        </div>
      </div>

      <.h2 underline class="mt-10" label="Chat Messages" />

      <div class="mt-8 rounded-lg border border-gray-200 dark:border-gray-800">
        <div class="flex flex-col divide-y divide-gray-200 dark:divide-gray-800">
          <%= for message <- @messages do %>
            <.chat_message
              message={message.message}
              sender={message.sender}
              timestamp={message.timestamp}
              is_self={message.is_self}
            />
          <% end %>

          <%= if @show_typing do %>
            <div class="p-4">
              <.typing_indicator sender="Alice" speed="normal" />
            </div>
          <% end %>
        </div>
      </div>

      <.h2 underline class="mt-10" label="Chat Input" />

      <.live_component
        module={ChatInput}
        id="chat-input-example"
        loading={@input_loading}
        on_submit={&handle_message/1}
        placeholder="Type your message here..."
      />

      <.h2 underline class="mt-10" label="Typing Indicators" />

      <div class="space-y-4">
        <div class="rounded-lg border border-gray-200 dark:border-gray-800 p-4">
          <.typing_indicator sender="Alice" speed="slow" />
        </div>

        <div class="rounded-lg border border-gray-200 dark:border-gray-800 p-4">
          <.typing_indicator sender="Bob" speed="normal" />
        </div>

        <div class="rounded-lg border border-gray-200 dark:border-gray-800 p-4">
          <.typing_indicator sender="Carol" speed="fast" />
        </div>
      </div>
    </.container>
    """
  end

  @doc """
  Handles the initial chat start
  """
  def handle_event("start_chat", %{"prompt" => prompt, "model" => model} = params, socket) do
    Logger.info("Starting chat with prompt: #{prompt} and model: #{model}")
    Logger.debug("Full params: #{inspect(params)}")

    # Add the user's initial message
    socket = add_ai_message(socket, prompt, "You", true)

    # Show typing indicator and schedule AI response
    send(self(), :show_typing)
    Process.send_after(self(), {:send_ai_response, model}, 2000)

    {:noreply, assign(socket, chat_started: true, input_loading: true)}
  end

  @doc """
  Handles new messages submitted through the ChatInput component
  """
  def handle_message(message) do
    send(self(), {:new_message, message})
  end

  @doc """
  Processes a new message and simulates a response
  """
  def handle_info({:new_message, message}, socket) do
    if socket.assigns.chat_started do
      # Add the user's message to AI chat
      socket = add_ai_message(socket, message, "You", true)

      # Simulate typing indicator for AI
      send(self(), :show_typing)
      # Schedule the AI response
      Process.send_after(self(), :send_ai_response, 3000)

      {:noreply, assign(socket, input_loading: true)}
    else
      # Add the user's message to demo chat
      socket = add_message(socket, message, "You", true)

      # Simulate typing indicator
      send(self(), :show_typing)
      # Schedule the response
      Process.send_after(self(), :send_response, 3000)

      {:noreply, assign(socket, input_loading: true)}
    end
  end

  def handle_info(:show_typing, socket) do
    {:noreply, assign(socket, show_typing: true)}
  end

  def handle_info({:send_ai_response, model}, socket) do
    response = "I'll be your AI assistant using the #{model} model. How can I help you today?"

    socket =
      socket
      |> assign(show_typing: false, input_loading: false)
      |> add_ai_message(response, "AI", false)

    {:noreply, socket}
  end

  def handle_info(:send_ai_response, socket) do
    responses = [
      "I understand. Let me help you with that.",
      "That's an interesting perspective. Here's what I think...",
      "Based on what you've shared, I would suggest...",
      "Let me process that and provide a thoughtful response...",
      "I can help you with that. Here's my analysis..."
    ]

    response = Enum.random(responses)

    socket =
      socket
      |> assign(show_typing: false, input_loading: false)
      |> add_ai_message(response, "AI", false)

    {:noreply, socket}
  end

  def handle_info(:send_response, socket) do
    responses = [
      "That's interesting! Tell me more.",
      "I see what you mean.",
      "Thanks for sharing that!",
      "How fascinating!",
      "I hadn't thought about it that way before."
    ]

    response = Enum.random(responses)

    socket =
      socket
      |> assign(show_typing: false, input_loading: false)
      |> add_message(response, "Alice", false)

    {:noreply, socket}
  end

  # Adds a new message to the messages list
  defp add_message(socket, content, sender, is_self) do
    new_message = %{
      message: content,
      sender: sender,
      timestamp: format_timestamp(DateTime.utc_now()),
      is_self: is_self
    }

    assign(socket, messages: socket.assigns.messages ++ [new_message])
  end

  # Adds a new message to the AI messages list
  defp add_ai_message(socket, content, sender, is_self) do
    new_message = %{
      message: content,
      sender: sender,
      timestamp: format_timestamp(DateTime.utc_now()),
      is_self: is_self
    }

    assign(socket, ai_messages: socket.assigns.ai_messages ++ [new_message])
  end

  # Formats the current timestamp for display
  defp format_timestamp(datetime) do
    datetime
    |> DateTime.to_time()
    |> Time.to_string()
    |> String.slice(0..4)
    |> Kernel.<>(if datetime.hour >= 12, do: "PM", else: "AM")
  end
end
