const { test, expect } = require('@playwright/test');

test.describe('Time Entry Management', () => {
  test.beforeEach(async ({ page }) => {
    // Login first
    await page.goto('/users/sign_in');
    await page.fill('input[name="user[email]"]', 'admin@example.com');
    await page.fill('input[name="user[password]"]', 'password123');
    await page.click('input[type="submit"]');
    await expect(page).toHaveURL('/');
  });

  test('should record time entry for employee', async ({ page }) => {
    // First create an employee if none exists
    await page.goto('/employees/new');
    await page.fill('input[name="employee[first_name]"]', 'Jane');
    await page.fill('input[name="employee[last_name]"]', 'Smith');
    await page.fill('input[name="employee[email]"]', 'jane.smith@company.com');
    await page.fill('input[name="employee[phone]"]', '555-5678');
    await page.fill('input[name="employee[hire_date]"]', '2024-01-20');
    await page.fill('input[name="employee[salary]"]', '65000');
    await page.fill('input[name="employee[position]"]', 'Designer');
    await page.fill('input[name="employee[department]"]', 'Design');
    await page.click('input[type="submit"]');
    
    // Now record time entry
    await page.click('text=Record Time Entry');
    await expect(page).toHaveURL('/time_entries/new');
    
    // Select employee from dropdown
    await page.selectOption('select[name="time_entry[employee_id]"]', { label: 'Jane Smith' });
    await page.fill('input[name="time_entry[work_date]"]', '2024-02-01');
    await page.fill('input[name="time_entry[hours_worked]"]', '8.0');
    await page.fill('input[name="time_entry[overtime_hours]"]', '2.0');
    await page.fill('textarea[name="time_entry[notes]"]', 'Worked on UI design project');
    
    // Submit form
    await page.click('input[type="submit"]');
    
    // Should show success message
    await expect(page.locator('.notice')).toContainText('Time entry was successfully created');
  });
});