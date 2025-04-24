defmodule PetalBoilerplateWeb.ChatData do
  def conversations do
    [
      %{
        id: "1",
        title: "Alice Smith",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Alice",
        last_message: "That would be great! Looking forward to your updates.",
        last_message_at: "2m ago",
        unread_count: 2
      },
      %{
        id: "2",
        title: "Bob Johnson",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Bob",
        last_message: "Let me know if you need any clarification.",
        last_message_at: "1h ago",
        unread_count: 0
      },
      %{
        id: "3",
        title: "Project Team",
        avatar_url: "https://api.dicebear.com/7.x/avataaars/svg?seed=Team",
        last_message: "Great progress everyone!",
        last_message_at: "3h ago",
        unread_count: 5
      }
    ]
  end

  def chat_history do
    %{
      "1" => [
        %{
          message: "Hey! How's the project coming along?",
          sender: "Alice Smith",
          timestamp: "09:30AM",
          is_self: false
        },
        %{
          message: "I've been working on the new features you requested",
          sender: "You",
          timestamp: "09:32AM",
          is_self: true
        },
        %{
          message: "The user authentication module is almost complete",
          sender: "You",
          timestamp: "09:32AM",
          is_self: true
        },
        %{
          message: "That's fantastic! Any challenges you've encountered?",
          sender: "Alice Smith",
          timestamp: "09:35AM",
          is_self: false
        },
        %{
          message: "Just some minor issues with the OAuth integration, but I found a solution",
          sender: "You",
          timestamp: "09:37AM",
          is_self: true
        },
        %{
          message: "Would you like to schedule a demo for tomorrow?",
          sender: "Alice Smith",
          timestamp: "09:38AM",
          is_self: false
        },
        %{
          message: "That would be great! Looking forward to your updates.",
          sender: "Alice Smith",
          timestamp: "09:40AM",
          is_self: false
        }
      ],
      "2" => [
        %{
          message: "I've reviewed the documentation you sent",
          sender: "Bob Johnson",
          timestamp: "08:15AM",
          is_self: false
        },
        %{
          message: "Thanks Bob! What do you think about the new API endpoints?",
          sender: "You",
          timestamp: "08:20AM",
          is_self: true
        },
        %{
          message: "The structure looks good, but we might want to add more validation",
          sender: "Bob Johnson",
          timestamp: "08:25AM",
          is_self: false
        },
        %{
          message: "Good point. Which endpoints specifically?",
          sender: "You",
          timestamp: "08:27AM",
          is_self: true
        },
        %{
          message:
            "The user registration and profile update endpoints could use more robust error handling",
          sender: "Bob Johnson",
          timestamp: "08:30AM",
          is_self: false
        },
        %{
          message: "I'll work on that today",
          sender: "You",
          timestamp: "08:32AM",
          is_self: true
        },
        %{
          message: "Let me know if you need any clarification.",
          sender: "Bob Johnson",
          timestamp: "08:35AM",
          is_self: false
        }
      ],
      "3" => [
        %{
          message: "Meeting scheduled for tomorrow at 10 AM",
          sender: "Project Team",
          timestamp: "07:00AM",
          is_self: false
        },
        %{
          message: "I'll prepare the sprint review presentation",
          sender: "You",
          timestamp: "07:05AM",
          is_self: true
        },
        %{
          message: "Don't forget to include the metrics from last week",
          sender: "Alice Smith",
          timestamp: "07:10AM",
          is_self: false
        },
        %{
          message: "I've updated the burndown chart",
          sender: "Bob Johnson",
          timestamp: "07:15AM",
          is_self: false
        },
        %{
          message: "The new features are ready for demo",
          sender: "You",
          timestamp: "07:20AM",
          is_self: true
        },
        %{
          message: "Excellent work on the UI improvements",
          sender: "Project Team",
          timestamp: "07:25AM",
          is_self: false
        },
        %{
          message: "Great progress everyone!",
          sender: "Project Team",
          timestamp: "07:30AM",
          is_self: false
        }
      ]
    }
  end
end
