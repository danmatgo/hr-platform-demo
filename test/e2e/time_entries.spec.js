const { test, expect } = require('@playwright/test');

test.describe('Time Entry Management', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/users/sign_in');
    await page.getByLabel('Email').fill('admin@example.com');
    await page.getByLabel('Password').fill('password123');
    await page.getByRole('button', { name: 'Sign in' }).click();
    await page.waitForLoadState('networkidle');
    await expect(page.getByRole('button', { name: 'Sign out' })).toBeVisible();
  });

  test('should record time entry for employee', async ({ page }) => {
    // First create an employee if none exists
    await page.goto('/employees/new');
    await page.getByLabel('First name').fill('Jane');
    await page.getByLabel('Last name').fill('Smith');
    await page.getByLabel('Email').fill('jane.smith@company.com');
    await page.getByLabel('Phone').fill('555-5678');
    await page.getByLabel('Hire date').fill('2024-01-20');
    await page.getByLabel('Salary').fill('65000');
    await page.getByLabel('Position').fill('Designer');
    await page.getByLabel('Department').fill('Design');
    await page.getByRole('button', { name: 'Create Employee' }).click();
    await expect(page.getByText('Employee was successfully created')).toBeVisible();
    
    // Now record time entry
    await page.goto('/time_entries/new');
    
    // Select employee from dropdown
    await page.getByLabel('Employee').selectOption({ label: 'Jane Smith' });
    await page.getByLabel('Work date').fill('2024-02-01');
    await page.getByLabel('Hours worked').fill('8.0');
    await page.getByLabel('Overtime hours').fill('2.0');
    await page.getByLabel('Notes').fill('Worked on UI design project');
    
    // Submit form
    await page.getByRole('button', { name: 'Create Time entry' }).click();
    
    // Should show success message
    await expect(page.getByText('Time entry was successfully created')).toBeVisible();
  });
});
