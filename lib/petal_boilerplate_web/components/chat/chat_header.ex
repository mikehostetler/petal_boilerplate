defmodule PetalBoilerplateWeb.Components.Chat.ChatHeader do
  use Phoenix.Component
  import PetalComponents.Avatar
  import PetalComponents.Typography
  import PetalComponents.Icon

  attr :title, :string, required: true, doc: "The title of the conversation"
  attr :participants, :list, default: [], doc: "List of participants in the conversation"
  attr :is_group, :boolean, default: false, doc: "Whether this is a group conversation"
  attr :avatar_url, :string, default: nil, doc: "URL of the avatar image for 1:1 chats"

  attr :status, :string,
    default: nil,
    doc: "Optional status text to display (e.g. 'online', 'typing...')"

  def chat_header(assigns) do
    ~H"""
    <header class="flex items-center justify-between p-4 border-b border-gray-200 dark:border-gray-800">
      <div class="flex items-center gap-3">
        <%= if @is_group do %>
          <div class="flex -space-x-2">
            <%= for participant <- Enum.take(@participants, 3) do %>
              <.avatar
                src={participant.avatar_url}
                size="sm"
                class="ring-2 ring-white dark:ring-gray-800"
                text={String.first(participant.name)}
              />
            <% end %>
            <%= if length(@participants) > 3 do %>
              <div class="flex items-center justify-center w-8 h-8 rounded-full bg-gray-200 dark:bg-gray-700 ring-2 ring-white dark:ring-gray-800">
                <span class="text-xs">+<%= length(@participants) - 3 %></span>
              </div>
            <% end %>
          </div>
        <% else %>
          <.avatar
            src={@avatar_url}
            size="sm"
            text={String.first(@title)}
          />
        <% end %>

        <div>
          <.h4 class="mb-0"><%= @title %></.h4>
          <%= if @status do %>
            <span class="text-sm text-gray-500 dark:text-gray-400"><%= @status %></span>
          <% else %>
            <span class="text-sm text-gray-500 dark:text-gray-400">
              <%= if @is_group do %>
                <%= length(@participants) %> participants
              <% end %>
            </span>
          <% end %>
        </div>
      </div>

      <div class="flex items-center gap-2">
        <button type="button" class="p-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
          <.icon name="hero-phone" class="w-5 h-5" />
        </button>
        <button type="button" class="p-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
          <.icon name="hero-video-camera" class="w-5 h-5" />
        </button>
        <button type="button" class="p-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
          <.icon name="hero-information-circle" class="w-5 h-5" />
        </button>
      </div>
    </header>
    """
  end
end
