import sys
from openai import OpenAI
from typing import List, Dict
import readline  # Improves input with arrow key support

class TerminalAI:
    def __init__(self):
        # Initialize the OpenAI client
        self.client = OpenAI(
            base_url="https://api-provider-b5s7.onrender.com/v1",
            api_key="any-key"
        )
        self.models = self._get_available_models()
        self.current_model = "deepseek-r1"  # Default model
        self.chat_history: List[Dict[str, str]] = []

    def _get_available_models(self) -> List[str]:
        """Fetch available models from the API."""
        try:
            models_response = self.client.models.list()
            # Assuming the API returns models in a similar structure to OpenAI
            return [model.id for model in models_response.data]
        except Exception as e:
            print(f"Error fetching models: {e}")
            return ["deepseek-r1"]  # Fallback to default

    def _display_models(self):
        """Display available models with numbers."""
        print("\nAvailable models:")
        for i, model in enumerate(self.models, 1):
            marker = "*" if model == self.current_model else " "
            print(f"{i}. {model} {marker}")

    def _select_model(self):
        """Handle model selection."""
        self._display_models()
        try:
            choice = input("\nEnter model number (or press Enter to keep current): ")
            if choice.strip() == "":
                print(f"Keeping current model: {self.current_model}")
                return
            choice = int(choice) - 1
            if 0 <= choice < len(self.models):
                self.current_model = self.models[choice]
                print(f"Selected model: {self.current_model}")
            else:
                print("Invalid selection. Keeping current model.")
        except ValueError:
            print("Please enter a valid number.")

    def _get_response(self, message: str) -> str:
        """Get AI response for the given message."""
        try:
            # Add user message to history
            self.chat_history.append({"role": "user", "content": message})
            
            # Create completion
            completion = self.client.chat.completions.create(
                model=self.current_model,
                messages=self.chat_history
            )
            
            # Get and store assistant response
            response = completion.choices[0].message.content
            self.chat_history.append({"role": "assistant", "content": response})
            return response
        except Exception as e:
            return f"Error: {str(e)}"

    def _display_help(self):
        """Display available commands."""
        print("\nCommands:")
        print("  /model    - Change the AI model")
        print("  /history  - Show conversation history")
        print("  /clear    - Clear conversation history")
        print("  /help     - Show this help message")
        print("  /exit     - Exit the program")

    def _display_history(self):
        """Display the conversation history."""
        if not self.chat_history:
            print("\nNo conversation history yet.")
            return
        
        print("\nConversation History:")
        for msg in self.chat_history:
            role = "You" if msg["role"] == "user" else "AI"
            print(f"{role}: {msg['content']}")

    def run(self):
        """Main loop for the terminal interface."""
        print("Welcome to Terminal AI!")
        print(f"Current model: {self.current_model}")
        print("Type '/help' for commands or start chatting!")
        
        while True:
            try:
                user_input = input(f"\n[{self.current_model}] You: ").strip()
                
                if not user_input:
                    continue
                    
                if user_input.startswith("/"):
                    command = user_input[1:].lower()
                    
                    if command == "exit":
                        print("Goodbye!")
                        break
                    elif command == "model":
                        self._select_model()
                    elif command == "history":
                        self._display_history()
                    elif command == "clear":
                        self.chat_history = []
                        print("Conversation history cleared.")
                    elif command == "help":
                        self._display_help()
                    else:
                        print("Unknown command. Type '/help' for available commands.")
                else:
                    response = self._get_response(user_input)
                    print(f"AI: {response}")
                    
            except KeyboardInterrupt:
                print("\nUse '/exit' to quit or continue typing.")
            except Exception as e:
                print(f"An error occurred: {e}")

if __name__ == "__main__":
    ai = TerminalAI()
    ai.run()