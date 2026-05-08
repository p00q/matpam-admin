$(document).ready(function() {
    const sidebar = $('#sidebar');
    const toggleBtn = $('#sidebarToggle');
    const toggleIcon = $('#toggleIcon');
    const mainWrapper = $('.main-wrapper');
    const topBar = $('.top-bar');

    // Load state from localStorage
    const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
    if (isCollapsed) {
        sidebar.addClass('collapsed');
        toggleIcon.removeClass('bi-chevron-left').addClass('bi-chevron-right');
    }

    // Toggle Sidebar
    toggleBtn.on('click', function() {
        sidebar.toggleClass('collapsed');
        const nowCollapsed = sidebar.hasClass('collapsed');
        localStorage.setItem('sidebarCollapsed', nowCollapsed);

        if (nowCollapsed) {
            toggleIcon.removeClass('bi-chevron-left').addClass('bi-chevron-right');
        } else {
            toggleIcon.removeClass('bi-chevron-right').addClass('bi-chevron-left');
        }
        
        // Trigger resize event to fix any layout issues in charts or tables
        setTimeout(() => {
            window.dispatchEvent(new Event('resize'));
        }, 500);
    });

    // Submenu Auto-Close on Collapse
    sidebar.on('transitionend', function(e) {
        if (e.originalEvent.propertyName === 'width' && sidebar.hasClass('collapsed')) {
            $('.collapse.show').collapse('hide');
        }
    });

    // Tooltip for collapsed state (optional)
    // If you want tooltips on icons when collapsed, add them here
});
