defmodule PetalBoilerplateWeb.Components.Chat.ChatStarter do
  use PetalBoilerplateWeb, :html
  require Logger

  alias PetalComponents.Form

  attr :on_submit, :any, required: true
  attr :loading, :boolean, default: false

  def chat_starter(assigns) do
    form = Phoenix.Component.to_form(%{"model" => "gpt-3.5-turbo"})
    Logger.debug("Form structure: #{inspect(form)}")

    # Test creating a form field directly to see its structure
    field_assigns = %{
      type: "select",
      form: form,
      field: :model,
      label: "Model",
      options: [
        [key: "GPT-3.5 Turbo", value: "gpt-3.5-turbo"],
        [key: "GPT-4", value: "gpt-4"],
        [key: "Claude", value: "claude"]
      ]
    }

    Logger.debug("Field assigns: #{inspect(field_assigns)}")

    assigns = assign(assigns, form: form)

    ~H"""
    <div class="w-full max-w-4xl mx-auto">
      <div class="rounded-lg border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900">
        <.form for={@form} as={:chat} phx-submit="start_chat" class="flex flex-col h-full">
          <div class="flex flex-col flex-grow">
            <div class="relative flex-grow">
              <textarea
                id="chat-prompt"
                name="prompt"
                class="w-full resize-none bg-transparent border-0 focus:ring-0 p-4 min-h-[120px] text-base placeholder:text-gray-500 text-gray-900 dark:text-gray-100"
                placeholder="What would you like to chat about?"
                required
                phx-hook="AutoResize"
              ></textarea>
              <div class="absolute bottom-3 right-4 text-xs text-gray-400 js-char-count"></div>
            </div>
            <div class="flex items-center justify-between p-4 bg-gray-50 dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700">
              <div class="flex-shrink-0">
                <.form_field {field_assigns} />
              </div>
              <.button
                type="submit"
                color="primary"
                phx-disable-with="Starting chat..."
                disabled={@loading}
              >
                Start Chat
              </.button>
            </div>
          </div>
        </.form>
      </div>
    </div>

    <script>
    document.addEventListener('DOMContentLoaded', () => {
      const textarea = document.getElementById('chat-prompt');
      const charCount = document.querySelector('.js-char-count');

      const updateTextarea = () => {
        const count = textarea.value.length;
        charCount.textContent = count > 0 ? `${count}/1000` : '';

        // Reset height to auto to properly calculate new height
        textarea.style.height = 'auto';
        // Set new height based on scrollHeight
        textarea.style.height = `${Math.min(textarea.scrollHeight, 400)}px`;
      };

      textarea.addEventListener('input', updateTextarea);
      textarea.addEventListener('change', updateTextarea);
    });
    </script>
    """
  end
end
