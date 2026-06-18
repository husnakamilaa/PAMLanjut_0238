import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

// CORS agar Flutter tidak diblokir
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle request OPTIONS (Preflight dari Flutter)
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // 1. Tangkap data pesanan dari Flutter
    const { order_id, gross_amount, customer_name, customer_email } = await req.json()

    // 2. Ambil Server Key Midtrans dari Secret Supabase
    // WAJIB: Set secret di terminal "supabase secrets set MIDTRANS_SERVER_KEY=SB-Mid-server-xxx"
    const serverKey = Deno.env.get('MIDTRANS_SERVER_KEY') || '';
    
    // 3. Encode Server Key ke Base64 (Syarat wajib Midtrans)
    const encodedKey = btoa(serverKey + ':');

    // 4. Tembak ke API Midtrans Sandbox
    const midtransResponse = await fetch('https://app.sandbox.midtrans.com/snap/v1/transactions', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': `Basic ${encodedKey}`
      },
      body: JSON.stringify({
        transaction_details: {
          order_id: order_id,
          gross_amount: gross_amount // Harga total harus angka (Integer)
        },
        customer_details: {
          first_name: customer_name,
          email: customer_email
        }
      })
    });

    const midtransData = await midtransResponse.json();

    // 5. Kembalikan data (Snap Token & Redirect URL) ke Flutter
    return new Response(JSON.stringify(midtransData), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})