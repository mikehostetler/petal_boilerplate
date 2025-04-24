defmodule PetalBoilerplateWeb.Components.Chat.ChatInput do
  @moduledoc """
  ChatInput is a flexible and interactive message input component for LiveView.

  ```elixir
  def render(assigns) do
    ~H\"\"\"
    <.live_chat_input
      id="chat-input"
      on_submit={fn message -> handle_message(message) end}
    />
    \"\"\"
  end
  ```

  ## Features
  * Handles Enter key for submission (with Shift+Enter for new lines)
  * Loading state management
  * Real-time message updates
  * Built with Petal Components

  ## Props
  * `id` - Required unique identifier for the component
  * `class` - Optional CSS classes to apply to the container
  * `on_submit` - Optional callback function when message is submitted
  * `placeholder` - Optional placeholder text for the input
  * `loading` - Optional boolean to control loading state
  """

  use Phoenix.LiveComponent
  use PetalBoilerplateWeb, :live_component

  # Component attributes
  attr :id, :string, required: true, doc: "Unique identifier for the component"
  attr :class, :string, default: nil, doc: "Additional CSS classes to apply"
  attr :on_submit, :any, doc: "Callback function when message is submitted"
  attr :placeholder, :string, default: "Type a message...", doc: "Placeholder text for the input"
  attr :loading, :boolean, default: false, doc: "Loading state of the component"

  def mount(socket) do
    {:ok, assign(socket, message: "", loading: false)}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(:id, assigns.id)
      |> assign(:class, Map.get(assigns, :class, ""))
      |> assign(:on_submit, Map.get(assigns, :on_submit))
      |> assign(:placeholder, Map.get(assigns, :placeholder, "Type a message..."))
      |> assign(:loading, Map.get(assigns, :loading, false))

    {:ok, socket}
  end

  @doc """
  Renders a ChatInput component in a given LiveView as a LiveComponent.

  Required attributes:
  - id: Unique identifier for the component

  Optional attributes:
  - class: Additional CSS classes
  - on_submit: Callback function for message submission
  - placeholder: Input placeholder text
  - loading: Loading state
  """
  def live_chat_input(assigns) do
    ~H"""
    <.live_component module={__MODULE__} {assigns} />
    """
  end

  def render(assigns) do
    ~H"""
    <div class={[
      "relative p-4 bg-gray-900 w-full",
      @class
    ]}>
      <form id={@id} phx-submit="send_message" phx-target={@myself} class="w-full">
        <.field
          type="textarea"
          name="message"
          value={@message}
          label="Message"
          label_class="sr-only"
          placeholder={@placeholder}
          class="w-full resize-none bg-gray-800 border-0 text-gray-100 placeholder-gray-400 rounded-lg focus:ring-0"
          container_class="m-0"
          rows="1"
          phx-keydown="handle_keydown"
          phx-target={@myself}
          required
        />
      </form>
    </div>
    """
  end

  def handle_event("handle_keydown", %{"key" => "Enter", "shiftKey" => false} = _params, socket) do
    if socket.assigns.message != "" do
      send_message(socket)
    else
      {:noreply, socket}
    end
  end

  def handle_event("handle_keydown", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("send_message", %{"message" => message}, socket) when message != "" do
    socket = assign(socket, message: message)
    send_message(socket)
  end

  def handle_event("send_message", _params, socket) do
    {:noreply, socket}
  end

  defp send_message(socket) do
    message = socket.assigns.message

    if socket.assigns[:on_submit] do
      socket.assigns.on_submit.(message)
    else
      send(self(), {:submit_message, message})
    end

    {:noreply, assign(socket, message: "", loading: true)}
  end
end
