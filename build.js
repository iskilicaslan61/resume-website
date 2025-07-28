const fs = require('fs');
const path = require('path');

// Build script to automatically sync src files with index.html
function buildWebsite() {
    console.log('🚀 Building website...');

    try {
        // Read the main index.html file
        let indexHtml = fs.readFileSync('index.html', 'utf8');

        // Content mapping
        const contentMap = {
            'berufserfahrungen': 'src/berufserfahrungen.html',
            'kompetenzen': 'src/kompetenzen.html',
            'projekte': 'src/projekte.html',
            'bildungs': 'src/bildungs.html',
            'kontakt': 'src/kontakt.html',
            'home': 'src/home.html'
        };

        let updatedCount = 0;

        // Replace each section with content from src files
        Object.keys(contentMap).forEach(sectionId => {
            const srcFile = contentMap[sectionId];

            if (fs.existsSync(srcFile)) {
                const srcContent = fs.readFileSync(srcFile, 'utf8');

                // Extract content from src file - try different patterns
                let extractedContent = '';

                // Pattern 1: Look for section div
                const sectionMatch = srcContent.match(/<div[^>]*class="[^"]*section[^"]*"[^>]*>([\s\S]*?)<\/div>/);
                if (sectionMatch) {
                    extractedContent = sectionMatch[1];
                }

                // Pattern 2: Look for kompetenzen-section
                if (!extractedContent) {
                    const kompetenzenMatch = srcContent.match(/<div[^>]*class="[^"]*kompetenzen-section[^"]*"[^>]*>([\s\S]*?)<\/div>/);
                    if (kompetenzenMatch) {
                        extractedContent = kompetenzenMatch[1];
                    }
                }

                // Pattern 3: Look for body content
                if (!extractedContent) {
                    const bodyMatch = srcContent.match(/<body[^>]*>([\s\S]*?)<\/body>/);
                    if (bodyMatch) {
                        extractedContent = bodyMatch[1];
                    }
                }

                // Pattern 4: Look for any content between tags
                if (!extractedContent) {
                    const contentMatch = srcContent.match(/>([\s\S]*?)</);
                    if (contentMatch) {
                        extractedContent = contentMatch[1];
                    }
                }

                if (extractedContent) {
                    // Find the section in index.html and replace its content
                    const sectionRegex = new RegExp(`(<section[^>]*id="${sectionId}"[^>]*>)[\\s\\S]*?(<\\/section>)`);

                    if (indexHtml.match(sectionRegex)) {
                        const replacement = `$1\n${extractedContent}\n$2`;
                        indexHtml = indexHtml.replace(sectionRegex, replacement);
                        console.log(`✅ Updated ${sectionId} section`);
                        updatedCount++;
                    } else {
                        console.log(`⚠️  Section ${sectionId} not found in index.html`);
                    }
                } else {
                    console.log(`⚠️  Could not extract content from ${srcFile}`);
                }
            } else {
                console.log(`❌ Source file not found: ${srcFile}`);
            }
        });

        // Write the updated index.html
        fs.writeFileSync('index.html', indexHtml);
        console.log(`🎉 Website build completed! Updated ${updatedCount} sections.`);

    } catch (error) {
        console.error('❌ Build failed:', error.message);
    }
}

// Run the build
buildWebsite(); 