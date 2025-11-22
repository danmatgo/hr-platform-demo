const { test, expect } = require('@playwright/test');

test.describe('Authentication', () => {
  test('should login successfully', async ({ page }) => {
    await page.goto('/');
    
    // Should be redirected to login page
    await expect(page).toHaveURL(/users/sign_in/);
    
    // Fill in login form
    await page.fill('input[name="user[email]"]', 'admin@example.com');
    await page.fill('input[name="user[password]"]', 'password123');
    
    // Submit form
    await page.click('input[type="submit"]');
    
    // Should be redirected to dashboard
    await expect(page).toHaveURL('/');
    await expect(page.locator('h1')).toContainText('HR Platform Dashboard');
  });

  test('should show error for invalid credentials', async ({ page }) => {
    await page.goto('/users/sign_in');
    
    // Fill in invalid credentials
    await page.fill('input[name="user[email]"]', 'wrong@example.com');
    await page.fill('input[name="user[password]"]', 'wrongpassword');
    
    // Submit form
    await page.click('input[type="submit"]');
    
    // Should show error message
    await expect(page.locator('.alert')).toContainText('Invalid Email or password');
  });
});