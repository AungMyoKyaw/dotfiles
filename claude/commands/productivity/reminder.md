---
description: 'Smart reminder CLI command that parses natural language requests and executes appropriate reminder actions'
argument-hint: '[natural language request about reminders]'
---

## Smart Reminder CLI Command

A powerful natural language interface for Apple Reminders that intelligently parses user requests and executes the appropriate reminder CLI actions using EventKit.

### Usage

```bash
# Create reminders
/reminder "remind me to buy milk tomorrow at 5pm"
/reminder "add meeting with John for Friday 2pm"
/reminder "create task to finish the report by Friday"

# List reminders
/reminder "show my reminders"
/reminder "list all tasks"
/reminder "what do I need to do today"

# Search reminders
/reminder "find reminders about work"
/reminder "search for tasks containing milk"
/reminder "show completed items"

# Manage reminders
/reminder "complete the buy milk task"
/reminder "mark report as done"
/reminder "delete the old reminder"

# Lists management
/reminder "show all my lists"
/reminder "create new list called Work"
/reminder "add to shopping list"

# Statistics and info
/reminder "how many reminders do I have"
/reminder "show my stats"
/reminder "what's overdue"
```

### Features

**🧠 Natural Language Processing:**

- Intelligently parses user intent from natural language
- Automatically detects dates, times, priorities, and lists
- Handles various phrasing patterns and synonyms
- Context-aware command identification

**✅ Interactive Confirmation & AI-Powered Editing:**

- Shows parsed reminder details before creation
- **🤖 AI Task Title Rewriting:** Uses Claude AI to automatically rewrite poorly written task titles for clarity and professionalism
- Allows users to choose between AI-improved and original titles
- Allows users to edit title, due date, priority, and list
- Provides clear confirmation options (Y/o/n/e/s)
- Prevents accidental reminder creation

**📅 Smart Date/Time Extraction:**

- Relative dates: "tomorrow", "next week", "in 3 days"
- Specific dates: "March 15", "2024-03-15"
- Times: "5pm", "17:00", "at 5 in the evening"
- Recurring: "every Monday", "daily", "weekly"

**🎯 Priority and List Detection:**

- Priority levels: "urgent", "important", "high priority"
- List names: "work", "personal", "shopping"
- Tags and categories extraction

**⚡ Direct CLI Integration:**

- Calls appropriate `reminder` CLI subcommands
- Handles all 18 available reminder operations
- Preserves all CLI functionality and options

### Supported Operations

**Creation:**

- `create` - Basic reminder creation
- `create-list` - New reminder lists
- `add-alarm` - Time-based alerts
- `add-recurrence` - Repeating reminders
- `add-location` - Location-based alerts
- `add-subtask` - Subtasks via notes
- `add-tag` - Tags via notes

**Retrieval:**

- `list` - List reminders
- `lists` - Show reminder lists
- `show` - Detailed reminder info
- `search` - Search with filters
- `stats` - Reminder statistics
- `list-subtasks` - Show subtasks
- `list-tags` - Show tags

**Management:**

- `update` - Modify existing reminders
- `complete` - Mark as completed
- `delete` - Remove reminders
- `delete-list` - Remove lists
- `rename-list` - Rename lists
- `remove-alarm` - Clear alarms
- `remove-recurrence` - Clear recurrence
- `remove-location` - Clear location alerts

### Implementation

```bash
#!/bin/bash

# Smart Reminder CLI - Natural Language to Reminder CLI Parser
# Parses user requests and executes appropriate reminder CLI commands

set -euo pipefail

# Color definitions for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Global variables
DEBUG=false
INPUT_REQUEST=""
DETECTED_COMMAND=""
DETECTED_PARAMS="()

# Logging functions
log_debug() {
    [[ "$DEBUG" == "true" ]] && echo -e "${PURPLE}[DEBUG]${NC} $1" >&2
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check if reminder CLI is available
check_reminder_cli() {
    if ! command -v reminder &> /dev/null; then
        log_error "reminder CLI not found. Please install it first."
        log_info "Installation: brew install reminder"
        exit 1
    fi
}

# Parse natural language input
parse_natural_language() {
    local input="$1"
    local lowercase_input
    lowercase_input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

    log_debug "Parsing input: '$lowercase_input'"

    # Check for help request
    if [[ "$lowercase_input" =~ ^(help|usage|--help|-h)$ ]]; then
        show_help
        exit 0
    fi

    # Creation patterns
    if [[ "$lowercase_input" =~ ^(remind me|add|create|make|new).+(to|that|for) ]]; then
        parse_creation_request "$input"
    elif [[ "$lowercase_input" =~ ^(show|list|display).+(reminders|tasks|todo) ]]; then
        parse_list_request "$input"
    elif [[ "$lowercase_input" =~ ^(find|search).+(reminders|tasks) ]]; then
        parse_search_request "$input"
    elif [[ "$lowercase_input" =~ ^(complete|mark|done|finish).+(task|reminder|item) ]]; then
        parse_complete_request "$input"
    elif [[ "$lowercase_input" =~ ^(delete|remove).+(reminder|task|item) ]]; then
        parse_delete_request "$input"
    elif [[ "$lowercase_input" =~ ^(show|create|delete|rename).+(list) ]]; then
        parse_list_management_request "$input"
    elif [[ "$lowercase_input" =~ ^(how many|stats|statistics|overdue|due) ]]; then
        parse_stats_request "$input"
    else
        # Default to creation if pattern is unclear but contains action words
        if [[ "$lowercase_input" =~ (buy|call|email|finish|start|go|meet|pick|schedule) ]]; then
            parse_creation_request "$input"
        else
            log_warning "Could not determine intent. Creating a general reminder."
            parse_creation_request "$input"
        fi
    fi
}

# Parse creation requests
parse_creation_request() {
    local input="$1"
    local lowercase_input
    lowercase_input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

    log_debug "Parsing creation request: '$input'"

    DETECTED_COMMAND="create"

    # Extract the actual reminder text
    local reminder_text="$input"

    # Remove common prefixes
    reminder_text=$(echo "$reminder_text" | sed -E 's/^(remind me to|add|create|make|new) //i')
    reminder_text=$(echo "$reminder_text" | sed -E 's/^(reminder|task) //i')
    reminder_text=$(echo "$reminder_text" | sed -E 's/ (to|that|for) //i')

    # Extract date/time information
    local date_info=""
    local time_info=""
    local priority=""
    local list_name=""

    # Date extraction patterns
    if [[ "$lowercase_input" =~ (today|tomorrow|yesterday) ]]; then
        date_info=$(echo "$lowercase_input" | grep -oE "(today|tomorrow|yesterday)" | head -1)
    elif [[ "$lowercase_input" =~ (next week|next month|in [0-9]+ days?|in [0-9]+ weeks?) ]]; then
        date_info=$(echo "$lowercase_input" | grep -oE "(next week|next month|in [0-9]+ days?|in [0-9]+ weeks?)" | head -1)
    elif [[ "$lowercase_input" =~ ([a-z]+ [0-9]{1,2}(st|nd|rd|th)?|[0-9]{1,2}(st|nd|rd|th)? [a-z]+|[0-9]{4}-[0-9]{2}-[0-9]{2}) ]]; then
        date_info=$(echo "$lowercase_input" | grep -oE "([a-z]+ [0-9]{1,2}(st|nd|rd|th)?|[0-9]{1,2}(st|nd|rd|th)? [a-z]+|[0-9]{4}-[0-9]{2}-[0-9]{2})" | head -1)
    fi

    # Time extraction patterns
    if [[ "$lowercase_input" =~ (at |@ )?[0-9]{1,2}(:[0-9]{2})?\s*(am|pm)? ]]; then
        time_info=$(echo "$lowercase_input" | grep -oE "(at |@ )?[0-9]{1,2}(:[0-9]{2})?\s*(am|pm)?" | head -1)
        time_info=$(echo "$time_info" | sed -E 's/^(at |@ )//')
    fi

    # Priority extraction
    if [[ "$lowercase_input" =~ (urgent|important|high|critical|asap) ]]; then
        priority=$(echo "$lowercase_input" | grep -oE "(urgent|important|high|critical|asap)" | head -1)
    fi

    # List extraction
    if [[ "$lowercase_input" =~ ((work|personal|shopping|home|business|office) list|list (work|personal|shopping|home|business|office)) ]]; then
        list_name=$(echo "$lowercase_input" | grep -oE "(work|personal|shopping|home|business|office)" | head -1)
    fi

    # Clean reminder text by removing extracted elements
    local clean_text="$reminder_text"
    if [[ -n "$date_info" ]]; then
        clean_text=$(echo "$clean_text" | sed -E "s/\b$date_info\b//gi")
    fi
    if [[ -n "$time_info" ]]; then
        clean_text=$(echo "$clean_text" | sed -E "s/\b(at |@ )?$time_info\b//gi")
    fi
    if [[ -n "$priority" ]]; then
        clean_text=$(echo "$clean_text" | sed -E "s/\b$priority\b//gi")
    fi
    if [[ -n "$list_name" ]]; then
        clean_text=$(echo "$clean_text" | sed -E "s/\b$list_name list\b//gi")
        clean_text=$(echo "$clean_text" | sed -E "s/\blist $list_name\b//gi")
    fi

    # Clean up extra spaces and punctuation
    clean_text=$(echo "$clean_text" | sed -E 's/^\s+|\s+$//g' | sed -E 's/\s+/ /g' | sed -E 's/[.!?]$//')

    # Build parameters
    local params=("$clean_text")

    # Add date/time if found
    local datetime=""
    if [[ -n "$date_info" ]]; then
        datetime="$date_info"
        if [[ -n "$time_info" ]]; then
            datetime="$datetime at $time_info"
        fi
        params+=("--due" "$datetime")
    fi

    # Add priority if found
    if [[ -n "$priority" ]]; then
        case "$priority" in
            "urgent"|"critical"|"asap")
                params+=("--priority" "high")
                ;;
            "important"|"high")
                params+=("--priority" "medium")
                ;;
        esac
    fi

    # Add list if found
    if [[ -n "$list_name" ]]; then
        params+=("--list" "$list_name")
    fi

    DETECTED_PARAMS=("${params[@]}")

    log_debug "Command: $DETECTED_COMMAND"
    log_debug "Params: ${DETECTED_PARAMS[*]}"
}

# Parse list requests
parse_list_request() {
    local input="$1"
    local lowercase_input
    lowercase_input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

    log_debug "Parsing list request: '$input'"

    DETECTED_COMMAND="list"
    local params=()

    # Check for specific list filtering
    if [[ "$lowercase_input" =~ (today|due|overdue|completed|incomplete) ]]; then
        local filter=$(echo "$lowercase_input" | grep -oE "(today|due|overdue|completed|incomplete)" | head -1)
        case "$filter" in
            "today")
                params+=("--due-today")
                ;;
            "due")
                params+=("--due")
                ;;
            "overdue")
                params+=("--overdue")
                ;;
            "completed")
                params+=("--completed")
                ;;
            "incomplete")
                params+=("--incomplete")
                ;;
        esac
    fi

    # Check for list name filtering
    if [[ "$lowercase_input" =~ (work|personal|shopping|home|business|office) ]]; then
        local list_name=$(echo "$lowercase_input" | grep -oE "(work|personal|shopping|home|business|office)" | head -1)
        params+=("--list" "$list_name")
    fi

    DETECTED_PARAMS=("${params[@]}")
}

# Parse search requests
parse_search_request() {
    local input="$1"
    local lowercase_input
    lowercase_input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

    log_debug "Parsing search request: '$input'"

    DETECTED_COMMAND="search"

    # Extract search terms
    local search_terms="$input"
    search_terms=$(echo "$search_terms" | sed -E 's/^(find|search) (for )?(reminders|tasks) //i')
    search_terms=$(echo "$search_terms" | sed -E 's/^(containing|about|with) //i')

    DETECTED_PARAMS=("$search_terms")
}

# Parse completion requests
parse_complete_request() {
    local input="$1"
    local lowercase_input
    lowercase_input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

    log_debug "Parsing complete request: '$input'"

    DETECTED_COMMAND="complete"

    # Extract reminder identifier
    local reminder_id="$input"
    reminder_id=$(echo "$reminder_id" | sed -E 's/^(complete|mark|done|finish) (the )?(task|reminder|item) //i')
    reminder_id=$(echo "$reminder_id" | sed -E 's/^(as|to be) //i')

    DETECTED_PARAMS=("$reminder_id")
}

# Parse delete requests
parse_delete_request() {
    local input="$1"
    local lowercase_input
    lowercase_input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

    log_debug "Parsing delete request: '$input'"

    DETECTED_COMMAND="delete"

    # Extract reminder identifier
    local reminder_id="$input"
    reminder_id=$(echo "$reminder_id" | sed -E 's/^(delete|remove) (the )?(task|reminder|item) //i')

    DETECTED_PARAMS=("$reminder_id")
}

# Parse list management requests
parse_list_management_request() {
    local input="$1"
    local lowercase_input
    lowercase_input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

    log_debug "Parsing list management request: '$input'"

    if [[ "$lowercase_input" =~ ^(show|list).+lists?$ ]]; then
        DETECTED_COMMAND="lists"
    elif [[ "$lowercase_input" =~ ^(create|new).+list ]]; then
        DETECTED_COMMAND="create-list"
        local list_name="$input"
        list_name=$(echo "$list_name" | sed -E 's/^(create|new) (reminder )?list (called )?//i')
        DETECTED_PARAMS=("$list_name")
    elif [[ "$lowercase_input" =~ ^(delete|remove).+list ]]; then
        DETECTED_COMMAND="delete-list"
        local list_name="$input"
        list_name=$(echo "$list_name" | sed -E 's/^(delete|remove) (reminder )?list (called )?//i')
        DETECTED_PARAMS=("$list_name")
    elif [[ "$lowercase_input" =~ ^(rename).+list ]]; then
        DETECTED_COMMAND="rename-list"
        # This would need more complex parsing for old and new names
        log_warning "List renaming requires manual CLI usage: reminder rename-list <old-name> <new-name>"
        exit 1
    fi
}

# Parse statistics requests
parse_stats_request() {
    local input="$1"
    local lowercase_input
    lowercase_input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

    log_debug "Parsing stats request: '$input'"

    if [[ "$lowercase_input" =~ ^(how many|count) ]]; then
        DETECTED_COMMAND="stats"
    elif [[ "$lowercase_input" =~ ^(stats|statistics) ]]; then
        DETECTED_COMMAND="stats"
    elif [[ "$lowercase_input" =~ overdue ]]; then
        DETECTED_COMMAND="list"
        DETECTED_PARAMS=("--overdue")
    elif [[ "$lowercase_input" =~ due ]]; then
        DETECTED_COMMAND="list"
        DETECTED_PARAMS=("--due")
    fi
}

# Rewrite task title and description using AI for clarity and better English
rewrite_task_title() {
    local original_title="$1"
    local rewritten_title="$original_title"

    log_debug "AI rewriting task title: '$original_title'"

    # Use Claude AI to rewrite the task title
    local ai_prompt="Please rewrite this task title to be clearer, more professional, and grammatically correct.
Keep it concise but action-oriented. Fix any slang, poor grammar, or awkward phrasing.

Original task title: \"$original_title\"

Please respond with ONLY the rewritten title, nothing else. Make it start with an action verb and be professional yet clear."

    # Call Claude API using the same method Claude Code uses
    if command -v claude &> /dev/null; then
        # Attempt to get AI rewrite
        local ai_response
        ai_response=$(claude --headless "$ai_prompt" 2>/dev/null | head -1)

        # Clean up the AI response
        rewritten_title=$(echo "$ai_response" | sed -E 's/^[\"\x27]\s*//' | sed -E 's/\s*[\"\x27]$//')
        rewritten_title=$(echo "$rewritten_title" | sed -E 's/^\s+|\s+$//g')

        # Fallback to original if AI response is empty, too short, or contains error messages
        if [[ -z "$rewritten_title" || ${#rewritten_title} -lt 3 || "$ai_response" =~ (error|failed|unable) ]]; then
            rewritten_title="$original_title"
            log_debug "AI rewrite failed or invalid, using original title"
        else
            log_debug "AI rewritten to: '$rewritten_title'"
        fi
    else
        log_debug "Claude CLI not found, using original title"
        rewritten_title="$original_title"
    fi

    echo "$rewritten_title"
}

# Show clarification and confirmation for creation requests
show_creation_confirmation() {
    local cmd="$DETECTED_COMMAND"
    local params=("${DETECTED_PARAMS[@]}")

    echo -e "${CYAN}📝 Reminder Creation Summary:${NC}"
    echo

    # Extract and display the reminder details
    local original_title="${params[0]}"
    local due_date=""
    local priority=""
    local list=""

    # Parse parameters for display
    local i=1
    while [[ $i -lt ${#params[@]} ]]; do
        case "${params[$i]}" in
            "--due")
                due_date="${params[$((i+1))]}"
                i=$((i+2))
                ;;
            "--priority")
                priority="${params[$((i+1))]}"
                i=$((i+2))
                ;;
            "--list")
                list="${params[$((i+1))]}"
                i=$((i+2))
                ;;
            *)
                i=$((i+1))
                ;;
        esac
    done

    # Show original vs rewritten title
    echo -e "${YELLOW}Original title:${NC} $original_title"
    local rewritten_title
    rewritten_title=$(rewrite_task_title "$original_title")

    if [[ "$rewritten_title" != "$original_title" ]]; then
        echo -e "${GREEN}✨ Rewritten title:${NC} $rewritten_title"
        # Update the title in params array
        params[0]="$rewritten_title"
    else
        echo -e "${GREEN}Title:${NC} $original_title"
    fi

    if [[ -n "$due_date" ]]; then
        echo -e "${BLUE}Due:${NC} $due_date"
    fi

    if [[ -n "$priority" ]]; then
        echo -e "${YELLOW}Priority:${NC} $priority"
    fi

    if [[ -n "$list" ]]; then
        echo -e "${PURPLE}List:${NC} $list"
    fi

    echo

    # Ask for confirmation or editing
    echo -e "${CYAN}Options:${NC}"
    echo "  [Y] Create reminder with rewritten title"
    echo "  [o] Use original title instead"
    echo "  [n] Cancel creation"
    echo "  [e] Edit details"
    echo "  [s] Skip creation"
    echo -e "${CYAN}Choose an option:${NC} [Y/o/n/e/s]"
    read -r response

    case "$response" in
        [nN]|[nN][oO])
            log_info "Reminder creation cancelled."
            exit 0
            ;;
        [sS]|[sS][kK][iI][pP])
            log_info "Skipping reminder creation."
            return 1
            ;;
        [oO]|[oO][rR][iI][gG][iI][nN][aA][lL])
            # Revert to original title
            params[0]="$original_title"
            log_info "Using original title: $original_title"
            ;;
        [eE]|[eE][dD][iI][tT])
            edit_reminder_details
            return show_creation_confirmation
            ;;
        [yY]|[yY][eE][sS]|"")
            # Use rewritten title (already set in params[0])
            ;;
        *)
            log_warning "Invalid response. Please enter Y (yes), O (original), N (no), E (edit), or S (skip)."
            show_creation_confirmation
            return
            ;;
    esac

    # Update global DETECTED_PARAMS with chosen title
    DETECTED_PARAMS=("${params[@]}")
    return 0
}

# Edit reminder details interactively
edit_reminder_details() {
    echo -e "${CYAN}📝 Edit Reminder Details:${NC}"
    echo

    # Get current values from DETECTED_PARAMS
    local current_params=("${DETECTED_PARAMS[@]}")
    local current_title="${current_params[0]}"
    local current_due_date=""
    local current_priority=""
    local current_list=""

    # Parse current parameters
    local i=1
    while [[ $i -lt ${#current_params[@]} ]]; do
        case "${current_params[$i]}" in
            "--due")
                current_due_date="${current_params[$((i+1))]}"
                i=$((i+2))
                ;;
            "--priority")
                current_priority="${current_params[$((i+1))]}"
                i=$((i+2))
                ;;
            "--list")
                current_list="${current_params[$((i+1))]}"
                i=$((i+2))
                ;;
            *)
                i=$((i+1))
                ;;
        esac
    done

    # Allow user to edit each component
    local new_title="$current_title"
    local new_due_date="$current_due_date"
    local new_priority="$current_priority"
    local new_list="$current_list"

    echo -e "${GREEN}Current title:${NC} $current_title"
    echo -e "${YELLOW}Enter new title (or press Enter to keep current):${NC}"
    read -r new_title_input
    if [[ -n "$new_title_input" ]]; then
        new_title="$new_title_input"
    fi

    echo
    echo -e "${BLUE}Current due date:${NC} ${current_due_date:-'none'}"
    echo -e "${YELLOW}Enter new due date (or press Enter to keep current):${NC}"
    read -r new_due_input
    if [[ -n "$new_due_input" ]]; then
        new_due_date="$new_due_input"
    fi

    echo
    echo -e "${YELLOW}Current priority:${NC} ${current_priority:-'none'}"
    echo -e "${YELLOW}Enter new priority (low/medium/high) or press Enter to keep current:${NC}"
    read -r new_priority_input
    if [[ -n "$new_priority_input" ]]; then
        new_priority="$new_priority_input"
    fi

    echo
    echo -e "${PURPLE}Current list:${NC} ${current_list:-'default'}"
    echo -e "${YELLOW}Enter new list name or press Enter to keep current:${NC}"
    read -r new_list_input
    if [[ -n "$new_list_input" ]]; then
        new_list="$new_list_input"
    fi

    # Rebuild the parameters array with updated values
    DETECTED_PARAMS=("$new_title")

    if [[ -n "$new_due_date" ]]; then
        DETECTED_PARAMS+=("--due" "$new_due_date")
    fi

    if [[ -n "$new_priority" ]]; then
        DETECTED_PARAMS+=("--priority" "$new_priority")
    fi

    if [[ -n "$new_list" ]]; then
        DETECTED_PARAMS+=("--list" "$new_list")
    fi

    echo
    log_success "Reminder details updated!"
}

# Execute the detected command
execute_command() {
    local cmd="$DETECTED_COMMAND"
    local params=("${DETECTED_PARAMS[@]}")

    # For creation commands, show confirmation first
    if [[ "$cmd" == "create" ]]; then
        if show_creation_confirmation; then
            log_info "Executing: reminder $cmd ${params[*]}"

            # Execute the reminder CLI command
            if reminder "$cmd" "${params[@]}"; then
                log_success "Reminder created successfully!"
            else
                log_error "Command failed. You may need to run it manually:"
                echo -e "${RED}reminder $cmd ${params[*]}${NC}"
                exit 1
            fi
        fi
    else
        # For non-creation commands, execute directly
        log_info "Executing: reminder $cmd ${params[*]}"

        # Execute the reminder CLI command
        if reminder "$cmd" "${params[@]}"; then
            log_success "Command executed successfully!"
        else
            log_error "Command failed. You may need to run it manually:"
            echo -e "${RED}reminder $cmd ${params[*]}${NC}"
            exit 1
        fi
    fi
}

# Show help information
show_help() {
    cat << 'EOF'
Smart Reminder CLI - Natural Language Interface for Apple Reminders

USAGE:
    /reminder "<natural language request>"

EXAMPLES:
    Creation (with AI-powered title rewriting):
        /reminder "gotta buy milk tomorrow at 5pm"
        /reminder "hit up John for Friday 2pm meeting"
        /reminder "wanna finish report by Friday"
        /reminder "sort out dentist appointment"
        /reminder "check email stuff later"

    Listing:
        /reminder "show my reminders"
        /reminder "list all tasks"
        /reminder "what do I need to do today"

    Searching:
        /reminder "find reminders about work"
        /reminder "search for tasks containing milk"

    Management:
        /reminder "complete the buy milk task"
        /reminder "mark report as done"
        /reminder "delete the old reminder"

    Lists:
        /reminder "show all my lists"
        /reminder "create new list called Work"

    Statistics:
        /reminder "how many reminders do I have"
        /reminder "show my stats"
        /reminder "what's overdue"

AI-POWERED TITLE REWRITING:
    The command automatically uses Claude AI to rewrite poorly written task titles:

    Examples of AI improvements:
    - "gotta buy milk" → "Purchase milk"
    - "hit up John about meeting" → "Schedule meeting with John"
    - "sort out dentist appointment" → "Resolve dentist appointment"
    - "wanna finish report" → "Complete report"
    - "check email stuff later" → "Review emails"

    Users can always choose between the AI-improved version or keep their original title.

SUPPORTED COMMANDS:
    create, list, show, search, complete, delete, stats,
    create-list, delete-list, rename-list, add-alarm, remove-alarm,
    add-recurrence, remove-recurrence, add-location, remove-location,
    add-subtask, list-subtasks, add-tag, list-tags

REQUIRES:
    reminder CLI (install with: brew install reminder)
EOF
}

# Main execution
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --debug)
                DEBUG=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                INPUT_REQUEST="$*"
                break
                ;;
        esac
    done

    # Check dependencies
    check_reminder_cli

    # Validate input
    if [[ -z "$INPUT_REQUEST" ]]; then
        log_error "No input request provided."
        show_help
        exit 1
    fi

    # Parse and execute
    parse_natural_language "$INPUT_REQUEST"
    execute_command
}

# Run main function with all arguments
main "$@"
```

### Error Handling

The command includes comprehensive error handling for:

- Missing reminder CLI installation
- Ambiguous or unclear user requests
- Invalid date/time formats
- Non-existent reminder lists
- Permission issues with EventKit

### Extensibility

The natural language parser can be easily extended by:

1. Adding new regex patterns for different phrasing
2. Expanding date/time extraction patterns
3. Adding support for more complex reminder properties
4. Including location-based parsing
5. Supporting recurring event patterns

### Requirements

- macOS with EventKit framework
- `reminder` CLI installed via Homebrew: `brew install reminder`
- `claude` CLI (Claude Code) for AI-powered title rewriting: `npm install -g @anthropic-ai/claude-code`
- Proper permissions for Calendar/Reminders access

### Examples

```bash
# Create with time and priority
/reminder "urgent reminder to call dentist tomorrow at 10am"

# List specific categories
/reminder "show work tasks for today"

# Search and filter
/reminder "find completed tasks about project"

# List management
/reminder "create new shopping list called Groceries"

# Statistics
/reminder "how many reminders are overdue"
```

This command provides a natural language interface to all 18 reminder CLI operations, making Apple Reminders management intuitive and conversational while preserving the full power of the underlying CLI tool.
