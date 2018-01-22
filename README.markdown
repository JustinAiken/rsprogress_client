# RS Progress Dashboard Client

Rake-based client for RS Progress dashboard.

## Setup

1. Create an empty git repo somewhere to store saved games in.
2. `cp config/config.example.yml config/config.yml`
3. Edit to taste

## Usage

- Immediately after each play session:
  - `rake progress:save progress:rip`
- Backup your notes and flags:
  - `rake flags:backup notes:backup`
