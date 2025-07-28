# Ismail Kilicaslan - DevOps & Cloud Engineer Resume Website

Modern, responsive resume website built with Node.js and Vite.

## 🚀 Features

- **Modern Build System**: Built with Vite for fast development and optimized production builds
- **Responsive Design**: Mobile-first approach with modern CSS Grid and Flexbox
- **Smooth Animations**: CSS animations and JavaScript interactions for better UX
- **SEO Optimized**: Semantic HTML structure for better search engine visibility
- **Performance Optimized**: Optimized assets and lazy loading for better performance

## 🛠️ Tech Stack

- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Build Tool**: Vite
- **Styling**: Custom CSS with CSS Variables
- **Icons**: Font Awesome
- **Fonts**: Google Fonts (Roboto)

## 📁 Project Structure

```
resume-website/
├── assets/                 # Static assets (images, icons)
│   ├── icons/             # Social media and company icons
│   └── images/            # Profile and background images
├── css/                   # Stylesheets
│   └── styles.css         # Main stylesheet
├── js/                    # JavaScript files
│   └── scripts.js         # Main JavaScript file
├── src/                   # Source HTML files (legacy)
├── index.html             # Main HTML file
├── package.json           # Node.js dependencies and scripts
├── vite.config.js         # Vite configuration
└── README.md              # Project documentation
```

## 🚀 Getting Started

### Prerequisites

- Node.js (version 16 or higher)
- npm or yarn

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd resume-website
```

2. Install dependencies:
```bash
npm install
```

3. Start development server:
```bash
npm run dev
```

The website will be available at `http://localhost:3000`

### Build for Production

```bash
npm run build
```

This will create a `dist` folder with optimized production files.

### Preview Production Build

```bash
npm run preview
```

## 📝 Available Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build for production
- `npm run preview` - Preview production build locally
- `npm run deploy` - Build and prepare for deployment

## 🎨 Customization

### Colors and Theme

The website uses CSS variables for easy customization. Edit the `:root` section in `css/styles.css`:

```css
:root {
    --primary-color: #252C64;
    --secondary-color: #FFD700;
    --text-color: #333;
    --background-color: #fff;
    --card-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    --transition: all 0.3s ease;
}
```

### Content

- Update personal information in `index.html`
- Replace profile image in `assets/images/`
- Update social media links and icons
- Modify sections as needed

## 🌐 Deployment

### Static Hosting

The built files in the `dist` folder can be deployed to any static hosting service:

- **Netlify**: Drag and drop the `dist` folder
- **Vercel**: Connect your repository
- **GitHub Pages**: Push to gh-pages branch
- **AWS S3**: Upload files to S3 bucket

### AWS S3 + CloudFront (Recommended)

This project includes Terraform configuration for AWS deployment:

```bash
cd terraform-static-website
terraform init
terraform plan
terraform apply
```

## 📱 Responsive Design

The website is fully responsive and optimized for:
- Desktop (1200px+)
- Tablet (768px - 1199px)
- Mobile (320px - 767px)

## 🔧 Development

### Adding New Sections

1. Add HTML structure to `index.html`
2. Style the section in `css/styles.css`
3. Add JavaScript functionality if needed in `js/scripts.js`

### Adding New Features

1. Install additional dependencies if needed:
```bash
npm install <package-name>
```

2. Import and use in your JavaScript files
3. Update Vite config if necessary

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**Ismail Kilicaslan**
- Email: ismail.kilicaslan@example.com
- LinkedIn: [linkedin.com/in/ismailkilicaslan](https://linkedin.com/in/ismailkilicaslan)
- GitHub: [github.com/ismailkilicaslan](https://github.com/ismailkilicaslan)

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

If you have any questions or need support, please contact me at ismail.kilicaslan@example.com

