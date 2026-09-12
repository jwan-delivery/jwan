// Legacy compatibility module. Automatic distance pricing is disabled in Jawan.
export const ROUTE_PRICE_PER_KM = null;
export async function quoteRoutePrice() {
  throw new Error("تم إلغاء التسعير التلقائي بالكيلومتر. السعر يحدده السائق بالتفاوض.");
}
