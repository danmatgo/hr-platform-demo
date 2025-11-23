const { test, expect } = require('@playwright/test');

test.describe('Benefits Management', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/users/sign_in');
    await page.getByLabel('Email').fill('admin@example.com');
    await page.getByLabel('Password').fill('password123');
    await page.getByRole('button', { name: 'Sign in' }).click();
    await page.waitForLoadState('networkidle');
    await expect(page.getByRole('button', { name: 'Sign out' })).toBeVisible();
  });

  test('should create benefit plan and enroll employee', async ({ page }) => {
    // First create a benefit plan
    await page.goto('/benefit_plans/new');
    await expect(page).toHaveURL('/benefit_plans/new');
    await page.getByLabel('Name').fill('Health Insurance Premium');
    await page.getByLabel('Description').fill('Comprehensive health insurance coverage for employees');
    await page.getByLabel('Cost').fill('500.00');
    await page.getByLabel('Coverage type').fill('Health');
    await page.getByRole('button', { name: 'Create Benefit plan' }).click();
    await expect(page.getByText('Benefit plan was successfully created')).toBeVisible();
    
    // Create an employee first
    await page.goto('/employees/new');
    await page.getByLabel('First name').fill('Bob');
    await page.getByLabel('Last name').fill('Johnson');
    await page.getByLabel('Email').fill('bob.johnson@company.com');
    await page.getByLabel('Phone').fill('555-9999');
    await page.getByLabel('Hire date').fill('2024-02-01');
    await page.getByLabel('Salary').fill('80000');
    await page.getByLabel('Position').fill('Manager');
    await page.getByLabel('Department').fill('Operations');
    await page.getByRole('button', { name: 'Create Employee' }).click();
    
    // Now create enrollment
    await page.goto('/enrollments/new');
    await expect(page).toHaveURL('/enrollments/new');
    await page.getByLabel('Employee').selectOption({ label: 'Bob Johnson' });
    await page.getByLabel('Benefit plan').selectOption({ label: 'Health Insurance Premium' });
    await page.getByLabel('Enrollment date').fill('2024-02-15');
    await page.getByLabel('Status').fill('Active');
    await page.getByRole('button', { name: 'Create Enrollment' }).click();
    await expect(page.getByText('Enrollment was successfully created')).toBeVisible();
  });
});
