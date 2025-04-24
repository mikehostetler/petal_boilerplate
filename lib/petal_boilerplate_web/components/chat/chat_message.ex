defmodule PetalBoilerplateWeb.Components.Chat.ChatMessage do
  use Phoenix.Component
  import PetalComponents.Avatar

  attr :message, :string, required: true
  attr :sender, :string, required: true
  attr :timestamp, :string, required: true
  attr :is_self, :boolean, default: false

  def chat_message(assigns) do
    ~H"""
    <div class={[
      "flex w-full gap-3 p-4",
      @is_self && "flex-row-reverse"
    ]}>
      <div class="flex-shrink-0">
        <.avatar size="sm" src={"https://ui-avatars.com/api/?name=#{@sender}&background=random"} />
      </div>
      <div class={[
        "flex max-w-[80%] flex-col gap-1",
        @is_self && "items-end"
      ]}>
        <div class="flex items-center gap-2">
          <span class="text-sm font-semibold text-gray-800 dark:text-gray-200"><%= @sender %></span>
          <span class="text-xs text-gray-500 dark:text-gray-400"><%= @timestamp %></span>
        </div>
        <div class={[
          "rounded-lg p-3",
          @is_self && "bg-primary-100 text-primary-900 dark:bg-primary-900 dark:text-primary-100",
          !@is_self && "bg-gray-100 text-gray-900 dark:bg-gray-800 dark:text-gray-100"
        ]}>
          <p class="text-sm"><%= @message %></p>
        </div>
      </div>
    </div>
    """
  end
end
