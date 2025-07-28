const fs = require('fs');
const path = require('path');

// Build script to automatically sync src files with index.html
function buildWebsite() {
    console.log('🚀 Building website...');

    // Read the main index.html file
    let indexHtml = fs.readFileSync('index.html', 'utf8');

    // Content mapping
    const contentMap = {
        'berufserfahrungen': 'src/berufserfahrungen.html',
        'kompetenzen': 'src/kompetenzen.html',
        'projekte': 'src/projekte.html',
        'bildungs': 'src/bildungs.html',
        'kontakt': 'src/kontakt.html'
    };

    // Replace each section with content from src files
    Object.keys(contentMap).forEach(sectionId => {
        const srcFile = contentMap[sectionId];

        if (fs.existsSync(srcFile)) {
            const srcContent = fs.readFileSync(srcFile, 'utf8');

            // Extract the content from src file
            const contentMatch = srcContent.match(/<div[^>]*class="[^"]*section[^"]*"[^>]*>([\s\S]*?)<\/div>/);
            const kompetenzenMatch = srcContent.match(/<div[^>]*class="[^"]*kompetenzen-section[^"]*"[^>]*>([\s\S]*?)<\/div>/);

            let extractedContent = '';
            if (contentMatch) {
                extractedContent = contentMatch[1];
            } else if (kompetenzenMatch) {
                extractedContent = kompetenzenMatch[1];
            } else {
                // Fallback: get everything between body tags
                const bodyMatch = srcContent.match(/<body[^>]*>([\s\S]*?)<\/body>/);
                if (bodyMatch) {
                    extractedContent = bodyMatch[1];
                }
            }

            if (extractedContent) {
                // Find the section in index.html and replace its content
                const sectionRegex = new RegExp(`(<section[^>]*id="${sectionId}"[^>]*>)[\\s\\S]*?(<\\/section>)`);
                const replacement = `$1\n${extractedContent}\n$2`;

                if (indexHtml.match(sectionRegex)) {
                    indexHtml = indexHtml.replace(sectionRegex, replacement);
                    console.log(`✅ Updated ${sectionId} section`);
                } else {
                    console.log(`⚠️  Section ${sectionId} not found in index.html`);
                }
            }
        } else {
            console.log(`❌ Source file not found: ${srcFile}`);
        }
    });

    // Write the updated index.html
    fs.writeFileSync('index.html', indexHtml);
    console.log('🎉 Website build completed!');
}

// Run the build
buildWebsite(); 