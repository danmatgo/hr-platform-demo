const { test, expect } = require('@playwright/test');

test.describe('Slow Report Performance Test', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/users/sign_in');
    await page.getByLabel('Email').fill('admin@example.com');
    await page.getByLabel('Password').fill('password123');
    await page.getByRole('button', { name: 'Sign in' }).click();
    await expect(page).toHaveURL('/dashboard/index');
  });

  test('should load employees report with intentional N+1 queries', async ({ page }) => {
    // Create multiple employees first to make the N+1 queries more noticeable
    for (let i = 1; i <= 5; i++) {
      await page.goto('/employees/new');
      await page.getByLabel('First name').fill(`Employee${i}`);
      await page.getByLabel('Last name').fill(`Test${i}`);
      await page.getByLabel('Email').fill(`employee${i}@test.com`);
      await page.getByLabel('Phone').fill(`555-000${i}`);
      await page.getByLabel('Hire date').fill('2024-01-15');
      await page.getByLabel('Salary').fill('50000');
      await page.getByLabel('Position').fill('Tester');
      await page.getByLabel('Department').fill('QA');
      await page.getByRole('button', { name: 'Create Employee' }).click();
      await expect(page.getByText('Employee was successfully created')).toBeVisible();
    }
    
    // Now visit the employees index page which has intentional N+1 queries
    const startTime = Date.now();
    await page.goto('/employees');
    await page.waitForLoadState('networkidle');
    await expect(page.getByRole('heading', { name: 'Employees' })).toBeVisible();
    const loadTime = Date.now() - startTime;
    
    // Verify the page loaded (even if slowly due to N+1 queries)
    await expect(page.getByRole('heading', { name: 'Employees' })).toBeVisible();
    await expect(page.getByText('New employee')).toBeVisible();
    
    // Log the load time for reference
    console.log(`Employees page load time: ${loadTime}ms`);
    
    // The page should show columns for N+1 data (time entries and benefits)
    await expect(page.getByText('Time entries')).toBeVisible();
    await expect(page.getByText('Benefits')).toBeVisible();
  });
});
