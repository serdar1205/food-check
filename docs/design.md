FoodCheck Flutter App - UI Design Specification ### Overall Design System Primary Color: Yellow/Gold (#**F9D342** or similar warm yellow) Background: Light gray/off-white (#**F5F5F5**) Text Primary: Dark gray/black (#**2D2D2D**) Text Secondary: Medium gray (#**8E8E8E**) Accent: White for cards and containers Border Radius: 12-16px for cards, 24px for buttons Font: San Francisco/Roboto, modern sans-serif

Screen 1: **SPLASH** **SCREEN** Layout:

Full screen centered content White/light background Yellow circular icon (128x128px) with megaphone/announcement symbol in center App name *FoodCheck* below icon in bold, large font (32px) Tagline below: "Проверяйте рестораны, оценивайте сервис и делитесь впечатлениями" in gray, smaller font (14px) Loading indicator at bottom (optional)

Elements:

Centered Column layout Logo icon: Yellow circle with megaphone icon Title: Bold, black text Subtitle: Regular weight, gray text All elements vertically centered with 16px spacing between

Screen 2: АВТОРИЗАЦИЯ (Authorization/Login) Layout:

White background Top section: Yellow circular logo (80x80px) with megaphone icon *FoodCheck* title below logo (24px bold) Section title *Авторизация* (20px bold, left-aligned) Subtitle *Войдите в свой аккаунт* (14px, gray)

Form Elements:

Email Input Field:

Label *Email* above (12px, gray) White rounded rectangle container (border radius 12px) Light gray border Envelope icon on left Placeholder: *[user@example.com](mailto:user@example.com)* Padding: 16px

Password Input Field:

Label *Пароль* above (12px, gray) White rounded rectangle container Lock icon on left Password dots (••••••••) Eye icon on right (show/hide password) Padding: 16px *Забыли пароль?* link in yellow/gold on bottom right (12px)

Login Button:

Full-width yellow rounded rectangle (border radius 24px) Text *Войти* centered, bold (16px) Height: 56px Margin top: 24px

Divider:

Text *или* centered with horizontal lines on sides Margin: 16px vertical

Spacing:

Form fields: 20px vertical spacing Container padding: 24px horizontal Top margin from logo to form: 40px

Screen 3: ГЛАВНАЯ - СПИСОК РЕСТОРАНОВ (Main - Restaurant List) Header:

Title *Рестораны* (24px bold) Search bar below with magnifying glass icon Placeholder: *Поиск ресторанов...* Border radius: 12px, light gray background

Filter Chips (Horizontal scrollable):

Yellow *Все* chip (selected state) White *Рядом*, *Популярные*, *Новые* chips Border radius: 20px Padding: 8px 16px Margin between: 8px

Restaurant List (Vertical ScrollView): Each restaurant card:

White rounded rectangle (border radius: 16px) Shadow: subtle elevation Padding: 16px Margin bottom: 12px

Card content:

Restaurant Icon: Circular 48x48px on left (pizza/food icon) Name: Bold 16px, black Address/Info: 12px gray below name Star Rating: 5 yellow stars (filled/outlined) on right side Rating Number: e.g., *4.5/5* below stars Right Arrow: Chevron icon for navigation

Layout: Row with icon left, text center-left, rating right

Screen 4: КАРТОЧКА ЗАВЕДЕНИЯ (Restaurant Detail) Header:

Back arrow (top left) Restaurant name *Пиццерия Наполи* (20px bold) Address *ул. Пушкина д. 12* (14px gray) below

Rating Section:

Large centered text *Общая оценка* 5 stars (4 filled gold, 1 outlined) - large size Text *Отлично!* below stars (green color)

Criteria Bars: Each criterion displayed as:

Label on left (14px): *Качество еды*, *Обслуживание*, *Атмосфера*, *Цена/Качество* Score on right: *8/10*, *7/10*, *9/10*, *6/10* Horizontal progress bar between (different colors):

Yellow for first Green for second Blue for third Orange for fourth

Bar height: 8px, border radius: 4px Spacing between bars: 16px

Action Buttons:

Yellow button (primary):

Text *📝 Загрузить чек* Full width, border radius: 24px Height: 56px

White button (secondary):

Text *📸 Сфотографировать чек* Full width border, border radius: 24px Height: 56px Border color: light gray

Spacing:

Section padding: 24px Vertical spacing between sections: 24px

Screen 5: СОЗДАНИЕ ОТЗЫВА (Create Review) Header:

Back arrow Title *Оценка сервиса* (20px bold) Subtitle *Оцените ваш визит в ресторан* (14px gray)

Restaurant Info:

Yellow circular icon (pizza) - 40x40px Name *Пиццерия Наполи* Address *ул. Пушкина д. 12* Layout: Row with icon left, text right

Overall Rating:

Text *Общая оценка* (16px) 5 large stars for tapping (4 filled yellow, 1 gray outlined as shown) Text *Отлично!* centered below (can change based on rating)

Criteria Rating Sliders/Bars: For each of 4 criteria:

Качество еды - 8/10

Yellow progress bar

Обслуживание - 7/10

Green progress bar

Атмосфера - 9/10

Blue progress bar

Цена/Качество - 6/10

Orange progress bar

Each has:

Label on left Score on right (X/10) Colored horizontal bar (width represents score) Bar height: 12px, border radius: 6px

Bottom Buttons:

Yellow *Загрузить чек* button (56px height, full width) White *Сфотографировать чек* button below

Spacing:

Padding: 24px Criteria spacing: 20px vertical

Screen 6: ЗАГРУЗКА ЧЕКА (Receipt Upload) Two options layout: Option 1: Camera Capture Screen

Full screen camera preview Top bar: Back button, *Чек* title Bottom controls:

Gallery icon (bottom left) Large yellow circular capture button (center) Settings/flash icon (bottom right)

Option 2: Preview Screen

Image preview of receipt (full width) Top: Back arrow, *Предпросмотр* title Bottom section (white card):

Receipt details text Yellow *Отправить* button (full width, 56px) Gray *Переснять* button below

Loading State:

Circular progress indicator Text *Обрабатываем чек...*

Error States:

Red alert icon Error message text *Чек уже использован* or *Ошибка загрузки* Yellow *Попробовать снова* button

Screen 7: РЕЗУЛЬТАТ (Result Screen) Success State:

Large green checkmark icon (80x80px) centered *Отзыв принят!* title (24px bold) Yellow star icon with *+50* bonus points *Вам начислено 50 бонусов* text (16px) Yellow *На главную* button at bottom

Error State:

Red X icon (80x80px) *Ошибка* title (24px bold) Error reason text (16px gray) Bullet points explaining issue Yellow *Попробовать снова* button Gray *Вернуться* button

Layout:

Centered column Icon at top Text with 16px spacing Buttons at bottom with safe area padding

Screen 8: ПРОФИЛЬ (Profile - Minimal) Header:

*Профиль* title (24px bold) Settings icon (top right)

User Info Card:

White rounded card (border radius: 16px) Profile avatar placeholder (circular, 64x64px) User name *Иван Иванов* (18px bold) Email below (14px gray)

Bonus Balance Card:

Yellow rounded card (border radius: 16px) Star icon (32x32px) *Ваши бонусы* label (14px) Large number *250* (32px bold) Small text *бонусных баллов* (12px)

Menu Items: List of white cards:

*История отзывов* with chevron right *Настройки* with chevron right *Помощь* with chevron right

Logout Button:

Red/gray text button at bottom *Выйти* with logout icon Border top separator

Spacing:

Cards margin: 12px vertical Section padding: 24px Items padding: 16px

### Navigation Structure

Bottom Navigation Bar (for main screens):

4 items with icons and labels:

Главная (home icon) - Restaurant list Карта (map icon) - Optional map view Отзывы (star icon) - My reviews Профиль (person icon) - Profile

Selected state: Yellow icon with yellow text Unselected: Gray icon with gray text Background: White with top border shadow

Common UI Components Buttons:

Primary (Yellow): #**F9D342**, white text, 56px height, 24px border radius Secondary (White): White background, gray border, dark text Disabled: Light gray background, gray text

Input Fields:

Height: 52px Border radius: 12px Border: 1px light gray (#**E0E0E0**) Focus: Yellow border Padding: 16px horizontal

Cards:

Background: White Border radius: 16px Shadow: 0px 2px 8px rgba(0,0,0,0.08) Padding: 16px

Icons:

Size: 24x24px (standard), 20x20px (small), 32x32px (large) Color: Match context (yellow for primary actions, gray for secondary)