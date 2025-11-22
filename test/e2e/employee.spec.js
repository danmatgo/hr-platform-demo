const { test, expect } = require('@playwright/test');

test.describe('Employee Management', () => {
  test.beforeEach(async ({ page }) => {
    // Login first
    await page.goto('/users/sign_in');
    await page.fill('input[name="user[email]"]', 'admin@example.com');
    await page.fill('input[name="user[password]"]', 'password123');
    await page.click('input[type="submit"]');
    await expect(page).toHaveURL('/');
  });

  test('should create a new employee', async ({ page }) => {
    await page.click('text=Add New Employee');
    await expect(page).toHaveURL('/employees/new');
    
    // Fill in employee form
    await page.fill('input[name="employee[first_name]"]', 'John');
    await page.fill('input[name="employee[last_name]"]', 'Doe');
    await page.fill('input[name="employee[email]"]', 'john.doe@company.com');
    await page.fill('input[name="employee[phone]"]', '555-1234');
    await page.fill('input[name="employee[hire_date]"]', '2024-01-15');
    await page.fill('input[name="employee[salary]"]', '75000');
    await page.fill('input[name="employee[position]"]', 'Software Engineer');
    await page.fill('input[name="employee[department]"]', 'Engineering');
    
    // Submit form
    await page.click('input[type="submit"]');
    
    // Should show success message and redirect to employee show page
    await expect(page.locator('.notice')).toContainText('Employee was successfully created');
    await expect(page.locator('h1')).toContainText('John Doe');
  });

  test('should list employees with N+1 queries', async ({ page }) => {
    await page.goto('/employees');
    
    // Should show employees list
    await expect(page.locator('h1')).toContainText('Employees');
    
    // The page intentionally has N+1 queries - this test verifies the page loads
    // even with the performance issues
    await expect(page.locator('#employees')).toBeVisible();
  });
});