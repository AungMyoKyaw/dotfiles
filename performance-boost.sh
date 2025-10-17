#!/bin/bash

# Performance Boost Script for macOS M1 Macs
# This script provides various optimizations to improve system performance
# WARNING: Some operations require sudo privileges

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is designed for macOS systems only"
        exit 1
    fi
}

# Function to check for M1 Mac
check_m1() {
    local arch=$(uname -m)
    if [[ "$arch" == "arm64" ]]; then
        print_success "Detected Apple Silicon (M1/M2/M3) Mac"
        return 0
    else
        print_warning "This script is optimized for Apple Silicon Macs, but will run on Intel Macs with limited functionality"
        return 1
    fi
}

# Function to check if running with sudo privileges
check_sudo() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Running with sudo privileges"
        return 0
    else
        print_status "Some operations require sudo privileges"
        return 1
    fi
}

# Function to prompt for confirmation
confirm_action() {
    local action="$1"
    read -p "Do you want to $action? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Memory Management Functions
show_memory_status() {
    print_status "Memory Status:"
    memory_pressure
    echo

    print_status "Top Memory Usage Processes:"
    top -l 1 -o mem | head -20
    echo
}

clear_memory_cache() {
    print_status "Clearing inactive memory..."
    if confirm_action "clear inactive memory (requires sudo)"; then
        sudo purge
        print_success "Memory cache cleared"
    fi
}

check_swap_usage() {
    print_status "Swap Usage:"
    sysctl vm.swapusage
}

# Developer-Specific Optimizations
check_rosetta_apps() {
    print_status "Checking for apps using Rosetta..."
    # This is a simplified check - in reality, you'd need to check each application
    local arch_check=$(arch -x86_64 uname -m 2>/dev/null || echo "arm64")
    if [[ "$arch_check" == "x86_64" ]]; then
        print_warning "Some applications may be running under Rosetta translation"
    else
        print_success "System appears to be running native ARM64 applications"
    fi
}

optimize_build_performance() {
    print_status "Build Performance Optimization:"
    local cpu_cores=$(sysctl -n hw.ncpu)
    echo "Available CPU cores: $cpu_cores"
    echo "For optimal build performance, use: make -j$cpu_cores"
}

suggest_fast_tools() {
    print_status "Recommended fast alternative tools:"
    echo "- Use 'ripgrep (rg)' instead of 'grep'"
    echo "- Use 'fd' instead of 'find'"
    echo "- Use 'bat' instead of 'cat' for syntax highlighting"
    echo "- Use 'exa' or 'lsd' instead of 'ls'"
}

# System Cleanup Functions
clear_system_caches() {
    print_status "Clearing system caches..."
    if confirm_action "clear system caches (requires sudo)"; then
        sudo rm -rf ~/Library/Caches/*
        print_success "System caches cleared"
    fi
}

clear_npm_cache() {
    if command -v npm &> /dev/null; then
        print_status "Clearing npm cache..."
        if confirm_action "clear npm cache"; then
            npm cache clean --force
            print_success "npm cache cleared"
        fi
    else
        print_status "npm not found, skipping npm cache cleanup"
    fi
}

clear_docker_cache() {
    if command -v docker &> /dev/null; then
        print_status "Clearing Docker cache..."
        if confirm_action "clear Docker cache"; then
            docker system prune -a
            print_success "Docker cache cleared"
        fi
    else
        print_status "Docker not found, skipping Docker cache cleanup"
    fi
}

# System Health Monitoring
check_disk_space() {
    print_status "Disk Space Usage:"
    df -h
}

check_memory_pressure() {
    print_status "Memory Pressure:"
    memory_pressure -l
}

check_cpu_temperature() {
    print_status "CPU Temperature and Usage:"
    if confirm_action "check CPU metrics (requires sudo)"; then
        sudo powermetrics --samplers cpu_power -i 1 -n 1 | grep -E "(CPU|temperature|power)" | head -20
    fi
}

# Advanced Tweaks
disable_spotlight_indexing() {
    print_status "Spotlight Indexing Control:"
    echo "To disable Spotlight indexing for specific directories:"
    echo "sudo mdutil -i off /path/to/directory"
    echo "To re-enable: sudo mdutil -i on /path/to/directory"

    if confirm_action "disable Spotlight indexing for /tmp (requires sudo)"; then
        sudo mdutil -i off /tmp 2>/dev/null || print_warning "Could not disable Spotlight indexing for /tmp"
    fi
}

add_time_machine_exclusion() {
    print_status "Time Machine Exclusion:"
    echo "To add Time Machine exclusions for cache directories:"
    echo "sudo tmutil addexclusion /path/to/cache"

    if confirm_action "add Time Machine exclusion for ~/Library/Caches (requires sudo)"; then
        sudo tmutil addexclusion ~/Library/Caches 2>/dev/null || print_warning "Could not add Time Machine exclusion"
    fi
}

# M1 Mac Specific Optimizations
show_unified_memory_info() {
    print_status "Unified Memory Information:"
    print_warning "M1 Macs have unified memory architecture - macOS manages memory efficiently"
    print_warning "Focus on memory pressure indicators rather than raw memory usage"

    # Show memory statistics
    vm_stat | perl -ne '/page_size of (\d+)/ and $size=$1; /Pages\s+(.+):\s+(\d+)/ and printf("%-16s % 16.2f MB\n", "$1:", $2 * $size / 1048576);'
}

suggest_cooling_solutions() {
    print_status "Thermal Management Suggestions:"
    echo "- Ensure good ventilation around your Mac"
    echo "- Consider a cooling stand for heavy compilation work"
    echo "- Monitor temperature with: sudo powermetrics --samplers thermal"
}

# Main Menu
show_menu() {
    echo -e "\n${BLUE}=== macOS Performance Boost Script ===${NC}"
    echo "1. Show Memory Status"
    echo "2. Clear Memory Cache"
    echo "3. Check Swap Usage"
    echo "4. Check for Rosetta Apps"
    echo "5. Show Build Optimization Tips"
    echo "6. Suggest Fast Tools"
    echo "7. Clear System Caches"
    echo "8. Clear npm Cache"
    echo "9. Clear Docker Cache"
    echo "10. Check Disk Space"
    echo "11. Check Memory Pressure"
    echo "12. Check CPU Temperature"
    echo "13. Spotlight Indexing Control"
    echo "14. Time Machine Exclusion"
    echo "15. Show Unified Memory Info"
    echo "16. Cooling Suggestions"
    echo "17. Run All Safe Optimizations"
    echo "18. Exit"
    echo
}

# Run all safe optimizations
run_all_safe() {
    print_status "Running all safe optimizations..."

    show_memory_status
    check_swap_usage
    check_rosetta_apps
    optimize_build_performance
    suggest_fast_tools
    clear_npm_cache
    clear_docker_cache
    check_disk_space
    check_memory_pressure
    show_unified_memory_info
    suggest_cooling_solutions

    print_success "All safe optimizations completed!"
}

# Main execution
main() {
    check_macos
    check_m1
    check_sudo

    while true; do
        show_menu
        read -p "Select an option (1-18): " choice
        echo

        case $choice in
            1) show_memory_status ;;
            2) clear_memory_cache ;;
            3) check_swap_usage ;;
            4) check_rosetta_apps ;;
            5) optimize_build_performance ;;
            6) suggest_fast_tools ;;
            7) clear_system_caches ;;
            8) clear_npm_cache ;;
            9) clear_docker_cache ;;
            10) check_disk_space ;;
            11) check_memory_pressure ;;
            12) check_cpu_temperature ;;
            13) disable_spotlight_indexing ;;
            14) add_time_machine_exclusion ;;
            15) show_unified_memory_info ;;
            16) suggest_cooling_solutions ;;
            17) run_all_safe ;;
            18) print_success "Exiting..."; exit 0 ;;
            *) print_error "Invalid option. Please select 1-18." ;;
        esac

        echo
        read -p "Press Enter to continue..."
        clear
    done
}

# Run the main function
main "$@"