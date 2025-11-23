const { test, expect } = require('@playwright/test');

test.describe('Employee Management', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/users/sign_in');
    await page.getByLabel('Email').fill('admin@example.com');
    await page.getByLabel('Password').fill('password123');
    await page.getByRole('button', { name: 'Sign in' }).click();
    await page.waitForLoadState('networkidle');
    await expect(page.getByRole('button', { name: 'Sign out' })).toBeVisible();
  });

  test('should create a new employee', async ({ page }) => {
    await page.goto('/employees');
    await page.click('text=New employee');
    await expect(page).toHaveURL('/employees/new');
    
    // Fill in employee form
    await page.getByLabel('First name').fill('John');
    await page.getByLabel('Last name').fill('Doe');
    await page.getByLabel('Email').fill('john.doe@company.com');
    await page.getByLabel('Phone').fill('555-1234');
    await page.getByLabel('Hire date').fill('2024-01-15');
    await page.getByLabel('Salary').fill('75000');
    await page.getByLabel('Position').fill('Software Engineer');
    await page.getByLabel('Department').fill('Engineering');
    
    // Submit form
    await page.getByRole('button', { name: 'Create Employee' }).click();
    
    // Should show success message and redirect to employee show page
    await expect(page.getByText('Employee was successfully created')).toBeVisible();
    await expect(page.getByText('John Doe')).toBeVisible();
  });

  test('should list employees with N+1 queries', async ({ page }) => {
    await page.goto('/employees');
    
    // Should show employees list
    await expect(page.getByRole('heading', { name: 'Employees' })).toBeVisible();
    
    // Verify UI elements present
    await expect(page.getByText('New employee')).toBeVisible();
  });
});
