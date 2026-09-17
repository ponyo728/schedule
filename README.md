## user

|Column            |Type  |Options    |
|------------------|------|-----------|
|email             |string|null: false, unique: true|
|encrypted_password|string|null: false|

### Association

 has_many :schedules

## schedule

|Column            |Type  |Options    |
|------------------|------|-----------|
|date              |date  |null: false|
|title             |string|null: false|
|start_time        |time  |null: false|
|end_time          |time  |null: false|
|detail            |text  |null: true |
|user_id           |references|null: false, foreign_key: true|

### Association

belongs_to :user