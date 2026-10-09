/*
 * Z2UI5_CL_SMP_APP_504: a quantity in the NESTED table that will not convert
 * is refused - Save reports it, and the cell carries the ValueState that
 * quotes the raw text (the row_parent path of t_model_skipped).
 */
export default async (page, { press, expectText, closePopups, waitForIdle }) => {
  const qty = page.locator('.sapMCLI input').first();
  await qty.fill('abc');
  await qty.press('Enter');
  await waitForIdle();
  const save = page.locator('button:visible', { hasText: 'Save' });
  if (!(await save.count())) await press('Additional Options');
  await press('Save');
  await expectText('Not saved', 'Save reported the refused quantity');
  await closePopups();
  const states = await page.evaluate(() => {
    const El = sap.ui.require('sap/ui/core/Element');
    return Object.values(El.registry.all())
      .filter((c) => c.getMetadata().getName() === 'sap.m.Input' && !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef()))
      .filter((c) => c.getValueState() === 'Error').map((c) => c.getValueStateText());
  });
  if (!states.some((t) => t.includes("'abc' is not a quantity"))) {
    throw new Error(`the nested quantity cell carries no Error state quoting 'abc' (states: ${JSON.stringify(states)})`);
  }
};
