const { test, expect } = require('@playwright/test');

test.describe('Slow Report Performance Test', () => {
  test.beforeEach(async ({ page }) => {
    // Login first
    await page.goto('/users/sign_in');
    await page.fill('input[name="user[email]"]', 'admin@example.com');
    await page.fill('input[name="user[password]"]', 'password123');
    await page.click('input[type="submit"]');
    await expect(page).toHaveURL('/');
  });

  test('should load employees report with intentional N+1 queries', async ({ page }) => {
    // Create multiple employees first to make the N+1 queries more noticeable
    for (let i = 1; i <= 5; i++) {
      await page.goto('/employees/new');
      await page.fill('input[name="employee[first_name]"]', `Employee${i}`);
      await page.fill('input[name="employee[last_name]"]', `Test${i}`);
      await page.fill('input[name="employee[email]"]', `employee${i}@test.com`);
      await page.fill('input[name="employee[phone]"]', `555-000${i}`);
      await page.fill('input[name="employee[hire_date]"]', '2024-01-15');
      await page.fill('input[name="employee[salary]"]', '50000');
      await page.fill('input[name="employee[position]"]', 'Tester');
      await page.fill('input[name="employee[department]"]', 'QA');
      await page.click('input[type="submit"]');
      await expect(page.locator('.notice')).toContainText('Employee was successfully created');
    }
    
    // Now visit the employees index page which has intentional N+1 queries
    const startTime = Date.now();
    await page.goto('/employees');
    const loadTime = Date.now() - startTime;
    
    // Verify the page loaded (even if slowly due to N+1 queries)
    await expect(page.locator('h1')).toContainText('Employees');
    await expect(page.locator('text=New employee')).toBeVisible();
    
    // Log the load time for reference
    console.log(`Employees page load time: ${loadTime}ms`);
    
    // The page should show columns for N+1 data (time entries and benefits)
    await expect(page.locator('text=Time entries')).toBeVisible();
    await expect(page.locator('text=Benefits')).toBeVisible();
  });
});
