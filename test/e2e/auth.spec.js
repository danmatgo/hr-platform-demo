const { test, expect } = require('@playwright/test');

test.describe('Authentication', () => {
  test('should login successfully', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveURL(/users\/sign_in/);
    await page.getByLabel('Email').fill('admin@example.com');
    await page.getByLabel('Password').fill('password123');
    await page.getByRole('button', { name: 'Sign in' }).click();
    await expect(page).toHaveURL('/');
    await page.waitForLoadState('networkidle');
    await expect(page.getByText('View All Paystubs')).toBeVisible();
    await expect(page.getByText('Request Time Off')).toBeVisible();
  });

  test('should show error for invalid credentials', async ({ page }) => {
    await page.goto('/users/sign_in');
    await page.getByLabel('Email').fill('wrong@example.com');
    await page.getByLabel('Password').fill('wrongpassword');
    await page.getByRole('button', { name: 'Sign in' }).click();
    await expect(page.getByText('Invalid')).toBeVisible();
  });
});
