Deno.serve(async (req) => {
    const corsHeaders = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
        'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, PUT, DELETE, PATCH',
        'Access-Control-Max-Age': '86400',
        'Access-Control-Allow-Credentials': 'false'
    };

    if (req.method === 'OPTIONS') {
        return new Response(null, { status: 200, headers: corsHeaders });
    }

    try {
        // Parse URL untuk mendapatkan hash parameter
        const url = new URL(req.url);
        const hash = url.searchParams.get('hash');

        if (!hash) {
            throw new Error('Hash parameter diperlukan');
        }

        // Query database untuk check hash
        const supabaseUrl = Deno.env.get('SUPABASE_URL');
        const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

        if (!supabaseUrl || !serviceRoleKey) {
            throw new Error('Konfigurasi Supabase tidak ditemukan');
        }

        const queryResponse = await fetch(
            `${supabaseUrl}/rest/v1/codex_entries?codex_hash=eq.${hash}&select=*`,
            {
                headers: {
                    'Authorization': `Bearer ${serviceRoleKey}`,
                    'apikey': serviceRoleKey
                }
            }
        );

        if (!queryResponse.ok) {
            const errorText = await queryResponse.text();
            console.error('Database query error:', errorText);
            throw new Error(`Gagal query database: ${errorText}`);
        }

        const entries = await queryResponse.json();

        if (entries.length === 0) {
            // Hash tidak ditemukan
            return new Response(JSON.stringify({
                data: {
                    status: 'invalid',
                    message: 'Hash tidak ditemukan di Codex Ledger'
                }
            }), {
                headers: { ...corsHeaders, 'Content-Type': 'application/json' }
            });
        }

        // Hash ditemukan - update verified status
        const entry = entries[0];
        
        const updateResponse = await fetch(`${supabaseUrl}/rest/v1/codex_entries?id=eq.${entry.id}`, {
            method: 'PATCH',
            headers: {
                'Authorization': `Bearer ${serviceRoleKey}`,
                'apikey': serviceRoleKey,
                'Content-Type': 'application/json',
                'Prefer': 'return=representation'
            },
            body: JSON.stringify({
                verified: true
            })
        });

        if (!updateResponse.ok) {
            console.error('Failed to update verification status');
        }

        return new Response(JSON.stringify({
            data: {
                status: 'verified',
                timestamp: entry.timestamp,
                ai_mode: entry.ai_mode,
                message: 'Hash terverifikasi di Codex Ledger'
            }
        }), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('Verify API error:', error);

        const errorResponse = {
            error: {
                code: 'VERIFY_FAILED',
                message: error.message
            }
        };

        return new Response(JSON.stringify(errorResponse), {
            status: 500,
            headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        });
    }
});
