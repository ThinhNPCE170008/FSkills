/**
 * Form Utilities for FSkills Project
 * Contains utility functions for form handling and validation
 */

/**
 * Pre-submission cleanup function that removes required attributes from hidden form elements
 * This prevents native HTML5 validation from blocking form submission for hidden required fields
 * 
 * @param {HTMLFormElement} form - The form element to clean up
 */
function cleanUpRequiredBeforeSubmit(form) {
    // Get all elements with the required attribute
    const requiredElements = form.querySelectorAll('[required]');
    
    requiredElements.forEach(element => {
        // Check if element is hidden using offsetParent (returns null if hidden)
        // or if it's a hidden input type
        if (element.offsetParent === null || element.type === 'hidden') {
            element.removeAttribute('required');
        }
    });
}

/**
 * Sets up automatic cleanup for a form before submission
 * Adds an event listener that runs the cleanup function before native validation
 * 
 * @param {HTMLFormElement|string} formSelector - Form element or CSS selector for form
 */
function setupFormCleanup(formSelector) {
    const form = typeof formSelector === 'string' 
        ? document.querySelector(formSelector) 
        : formSelector;
    
    if (!form) {
        console.warn('Form not found for cleanup setup:', formSelector);
        return;
    }
    
    // Add event listener with capture phase to ensure it runs before native validation
    form.addEventListener('submit', function(event) {
        cleanUpRequiredBeforeSubmit(this);
    }, true); // Using capture phase
}

/**
 * Auto-setup function that finds all forms and sets up cleanup
 * Can be called when DOM is loaded to automatically setup all forms
 */
function autoSetupFormCleanup() {
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        setupFormCleanup(form);
    });
}

/**
 * Advanced cleanup function that also handles elements made invisible through CSS
 * This version checks for more comprehensive hiding methods
 * 
 * @param {HTMLFormElement} form - The form element to clean up
 */
function cleanUpRequiredBeforeSubmitAdvanced(form) {
    const requiredElements = form.querySelectorAll('[required]');
    
    requiredElements.forEach(element => {
        const isHidden = (
            // Hidden by offsetParent (display: none or visibility: hidden)
            element.offsetParent === null ||
            // Hidden input type
            element.type === 'hidden' ||
            // Hidden by CSS display property
            window.getComputedStyle(element).display === 'none' ||
            // Hidden by CSS visibility property
            window.getComputedStyle(element).visibility === 'hidden' ||
            // Hidden by opacity
            window.getComputedStyle(element).opacity === '0' ||
            // Check if parent containers are hidden
            element.closest('[style*="display: none"], [style*="visibility: hidden"], [hidden]')
        );
        
        if (isHidden) {
            element.removeAttribute('required');
        }
    });
}

// Export functions if using modules (for compatibility)
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        cleanUpRequiredBeforeSubmit,
        setupFormCleanup,
        autoSetupFormCleanup,
        cleanUpRequiredBeforeSubmitAdvanced
    };
}

// Auto-setup when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Comment out the auto-setup to allow manual control
    // Uncomment the line below to enable automatic setup for all forms
    // autoSetupFormCleanup();
    
    console.log('Form utilities loaded. Use setupFormCleanup() to enable cleanup for specific forms.');
});

/*
 * USAGE EXAMPLES:
 * 
 * 1. Manual cleanup before form submission:
 *    form.addEventListener('submit', function(e) {
 *        cleanUpRequiredBeforeSubmit(this);
 *        // Your other validation logic here
 *    });
 * 
 * 2. Automatic setup for a specific form:
 *    setupFormCleanup('#myFormId');
 *    // or
 *    setupFormCleanup(document.getElementById('myFormId'));
 * 
 * 3. Setup for all forms automatically:
 *    autoSetupFormCleanup();
 * 
 * 4. Advanced cleanup (checks more hiding methods):
 *    form.addEventListener('submit', function(e) {
 *        cleanUpRequiredBeforeSubmitAdvanced(this);
 *    });
 */