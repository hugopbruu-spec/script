-- Este arquivo foi protegido usando Luraph Obfuscator v14.4.2 [https://lura.ph/]

return (function(...)
    local unpack = unpack
    local table_create = table.create
    local bit32_band = bit32.band
    local string_pack = string.pack
    local table_move = table.move
    local string_sub = string.sub
    local string_byte = string.byte
    local setmetatable = setmetatable
    local bit32_countlz = bit32.countlz
    local bit32_bxor = bit32.bxor
    local bit32_rshift = bit32.rshift
    local getfenv = getfenv
    local bit32_bnot = bit32.bnot
    local select = select
    local bit32_countrz = bit32.countrz
    local bit32_bor = bit32.bor
    local bit32_lshift = bit32.lshift
    local string_unpack = string.unpack
    local coroutine_yield = coroutine.yield
    local bit32_lrotate = bit32.lrotate
    local setfenv = setfenv
    local bit32_band = bit32.band

    local constants = {
        31992, 1170507935, 2584589478, 2596113251, 4210444458,
        1925823886, 3185202988, 2048398193, 875052589
    }

    local internal_functions = {}

    internal_functions.func_ni = function(S, J)
        return S[30963]
    end

    internal_functions.func_Vo = function(S, H)
        local C = S[1][0x63]()
        local H = #C
        local Z = 0x44
        return C, Z, H
    end

    internal_functions.func_lo = function(J)
        return J[30963]
    end

    internal_functions.func_qo = function(H)
        local J = H % 8
        local C = S[1][0x53]()
        return C, J
    end

    internal_functions.func_Jo = function(C, H)
        J[H + 1] = C
        local S = 0x153
        return S
    end

    internal_functions.func_F = function(S, J, H)
        if not(J > 0x4b) then
            local C, Z = H[1][0x10](S.R, H[1][0xb], H[1][0x4])
        elseif J <= 0x279_1 then
            H[1][0x4] = Z
            return 0xb01, Z, C
        else
            return { C }, Z, C
        end
    end

    internal_functions.func_di = bit32.band

    internal_functions.func_Ri = function(C, J, h)
        C[6][10] = S.T
        if not J[0x68e5] then
            local H = 0x56 + (S.Ui((S.Ui(S.l[2])) - J[30963] + J[0x64b0]))
            J[0x68e5] = H
        else
            H = S:si(J, H)
        end
        return H
    end

    internal_functions.func_co = function(J, C)
        S[J] = H[1][0xd][C]
    end

    internal_functions.func_Li = function(J, C, d)
        local Y
        local Z = 0x6a
        if not(J > 0x76) then
            d = S:Qi(H, d)
        elseif C == 0x147 then
            -- vazio
        else
            H[1][10] = C
            if -(0xf8 % 0x166) then
                Y = S:oi(C, H)
                if Y ~= nil then
                    return { S.d(Y) }, Z, d
                end
            end
        end
        d = H[1][0x1f]()
    end

    internal_functions.func_So = function(J, C, F)
        local a = nil
        local m = 0x15
        local X = 0x15
        local h, u
        while true do
            if not(m <= 0x15) then
                m, J, z, Z, a = S:To(c, Z, m, H, i, u, a, d, X, J, C, G, k)
                if z ~= 29503 then
                    -- vazio
                else
                    break
                end
            else
                if not(m < 0x15) then
                    m = 0x70
                    h = _ % 8
                    continue
                else
                    m, X = S:wo(g, h, X, u, _, a, m)
                    continue
                end
            end
        end

        if h == 0x3 then
            if not(F[1][0x11e]) then
                j[u] = F[1][0x55][X]
            else
                z, h = S:Uo(F, s, k, u, h, Z, X)
                if z ~= nil then
                    return h, { S.d(z) }, a, J, Z
                end
            end
        elseif h == 0x6 then
            H[u] = X
        else
            if h == 0x0 then
                H[u] = u + X
            elseif h == 0x7 then
                H[u] = u - X
            elseif h == 0x5 then
                S:po(F, X, j, u)
            end
        end

        if J == 0x3 then
            if F[3] ~= F[1][9] then
                if F[1][0x1e] then
                    _ = nil
                    C = nil
                    i = 0x4f
                    while true do
                        if i > 0x4f then
                            C = #_
                            break
                        elseif i < 0x61 then
                            i = 0x62
                            _ = F[1][0x15][Z]
                            continue
                        end
                    end
                end
            end
        else
            if J == 0x6 then
                S:io(u, c, Z)
            elseif J == 0x0 then
                c[u] = u + Z
            elseif J == 0x7 then
                c[u] = u - Z
            elseif J ~= 0x5 then
                -- vazio
            else
                d = nil
                G = 0x7c
                repeat
                    G, z, d = S:Zo(G, F, Y, d)
                    if z == 0x87fb then
                        break
                    elseif z == 64524 then
                        continue
                    end
                until false
                F[1][0xf][d + 2] = u
                F[1][0xf][d + 3] = Z
            end
        end
    end

    internal_functions.func_ro = function(J)
        local C
        while J[2] do
            C = S:Po()
            return { S.d(C) }
        end
    end

    internal_functions.func_bi = function(J, C)
        local H = 0x65
        repeat
            if H == 0x65 then
                H = S:Ai(H, J, C)
            else
                return { J }
            end
        until false
    end

    internal_functions.func_Do = function(J, C)
        local H
        if J > 0 then
            H = S:ro(C)
            if H == 65430 then
                return 62761, J
            elseif H == nil then
                -- vazio
            else
                return { S.d(H) }, J
            end
        else
            if not(J < 0x5f) then
                -- vazio
            else
                J = 0x5f
                C[1][0x1c], C[1][14] = C[1][0xa], C[1][0x1d]
            end
        end
    end

    internal_functions.func_Zi = string.pack
    internal_functions.func_Ii = function(J)
        J[1][25], J[1][0x23] = J[1][0x49], (S)
    end

    internal_functions.func_Yo = function(J, C)
        C[S] = S - J
    end

    internal_functions.func_Co = function(C)
        local J = C[1][0x23]()
        local S = C[1][35]()
        return S, J
    end

    internal_functions.func_f = function(J, C)
        local C = 3 + (S.ii((S.Ni((S.ki(S.l[6] - J[12922], (J[0x23e6]))))), (J[16355])))
        J[0x1f91] = C
        return C
    end

    internal_functions.func_Pi = function(J)
        local C = (J[1][0x50] - 0xE064)
        local S = 71
        J[1][21] = J[2](C)
        return C, S
    end

    internal_functions.func_n = bit32.countlz

    internal_functions.func_hi = bit32.bxor

    internal_functions.func_Di = function(J)
        J = nil
        local C
        local H
        local Z = nil
        for d = 0x75, 0xe6, 0x19 do
            if d > 0x75 then
                local J, Z = S:Pi(Z, C, J)
                H = S:ri(C, H)
            else
                if d < 0xe6 then
                    C[1][0xd] = {}
                end
            end
        end
        return H, J, Z
    end

    internal_functions.func_go = function()
        local H, Y, C, Z, S, h, J, d
        d = nil
        Y = nil
        S = nil
        J = nil
        H = nil
        Z = nil
        C = nil
        h = nil
        return H, Y, C, Z, S, h, J, d
    end

    internal_functions.func_Ko = function(J, C, d)
        if Y[1][33] ~= Y[1][0xe] then
            S:eo(H, Z, d, C)
        end
        d[5] = J
    end

    internal_functions.func_k = bit32.rshift

    internal_functions.func_v = getfenv

    internal_functions.func_so = function(J)
        local C = S[2](J)
        return C
    end

    internal_functions.func_V = function(J, C)
        J[12] = S.b.sub
        if not(not H[1032]) then
            C = H[1032]
        else
            C = -0x65f41013 + (S.Gi(H[26313] - H[0x23e6] + S.l[5] <= S.l[1] and S.l[5] or S.l[3]))
            H[0x408] = C
        end
        return C
    end

    internal_functions.func_h = function(J)
        local C = {}
        J[1] = S.o.bxor
        J[2] = S.Q
        local Z
        local d = S.L
        Z = {}
        local H
        J[0x4] = nil
        H = nil
        J[5] = nil
        local Y = 0x3b
        while true do
            if Y == 0x3b then
                Y, H = S:U(H, J, Y, C)
                continue
            else
                J[5] = S.E
                break
            end
        end
        J[6] = {}
        J[7] = nil
        return d, C, Y, Z, H
    end

    internal_functions.func_pi = string.unpack

    internal_functions.func_y = function(J)
        H[0x15] = S.W
        if not C[0x1f91] then
            J = S:f(C, J)
        else
            J = C[0x1f91]
        end
        return J
    end

    internal_functions.func_To = function(J, C, h)
        if not(H <= 0x19) then
            H, C, h, _ = S:Mo(H, _, J, c, h, d, j, F, Z, C, Y)
        else
            a[Y] = u
            return H, _, 29503, C, h
        end
    end

    internal_functions.func_c = function(J)
        J[0x1][23] = S
        J[1][0x4] = 0x1
    end

    internal_functions.func_Uo = function(J, Z)
        local u = 0x181
        local F
        local _
        while true do
            if u <= 0x2c then
                if u < 0x2c then
                    u = S:ko(C, u, _, F)
                else
                    u = 0x1b
                    _ = #F
                    if J[1][0x145] ~= J[3] then
                        -- vazio
                    else
                        for C = 0x4d, 0xb1, 0x34 do
                            if C == 0x65 then
                                while H do
                                    return { J[1][0x53] }, Z
                                end
                                break
                            elseif C == 101 then
                                d = S:ao(Z, J, Y)
                                continue
                            end
                        end
                    end
                    continue
                end
            else
                if u <= 0x3e then
                    F[_ + 2] = Z
                    F[_ + 3] = 0x8
                    break
                else
                    F = J[1][21][h]
                    u = 0x2c
                    continue
                end
            end
        end
    end

    internal_functions.func_Xi = function(J, C)
        if H > 0x68 then
            if -0xc8 > 46 - 0xd8 then
                S:Ii(J, C)
            end
            H = 104
            return 0x6560, H
        else
            local Z = S:li(C)
            if Z == 0x72e7 then
                return 22847, H
            elseif Z == nil then
                -- vazio
            else
                return { S.d(Z) }, H
            end
        end
    end

    internal_functions.func_Ai = function(J, C)
        if 0xeb + 0x50 > J then
            C[1][9], C[1][0xa] = -C[1][35], J
        end
        local S = 0x0
        return S
    end

    internal_functions.func_Ni = bit32.countlz

    internal_functions.func_wo = function(h, X)
        local Y = 34
        local C = (Z - J) / 8
        S[H] = d
        return Y, C
    end

    internal_functions.func_t = function(J, C)
        C[8] = S.A.move
        if not(not H[0x4194]) then
            J = S:p(H, J)
        else
            J = S:G(H, J)
        end
        return J
    end

    internal_functions.func_Fo = function(J, C)
        local C = -0x53 + (S.hi((S.hi(J[16788], J[7147], J[0x1beb])) - J[0x4fe]) ~= S.l[3] and J[0x57c7] or J[78])
        J[0x19d7] = C
        return C
    end

    internal_functions.func_b = string
    -- internal_functions.func_H = H -- Function H está definida mais adiante

    internal_functions.func_e = setmetatable

    internal_functions.func_qi = function(J, C)
        H[0xe] = S.ti
        if not(not H[30258]) then
            C = H[0x7632]
        else
            H[24553] = 0x85 + (S.ii((S.di(H[23128], H[0x69b6], H[1032])) - H[0x66c9] + S.l[6], (H[0x69b6])))
            local Z = -0xc + (H[0x4194] + H[16788] - H[0x64b0] + H[0x559d] - H[0x57c7])
            H[0x7632] = Z
        end
        return C
    end

    internal_functions.func_D = nil -- Function D está definida mais adiante
    internal_functions.func_D = function(...)
    end

    internal_functions.func_Y = function(J, C)
        J[C] = S(C)
    end

    internal_functions.func_Ro = function(J, C)
        local S = H[10](J)
        local C = H[2](J)
        return S, C
    end

    internal_functions.func_mo = function(Z)
        local h
        local Y
        local F = nil
        local J = nil
        for _ = 13, 0x304, 0x3f do
            if _ == 0xd then
                local h, Z = S:Co(h, Z, d)
                continue
            else
                if _ ~= 0x4c then
                    -- vazio
                else
                    J, F = S:qo(d, F, J, Z)
                end
            end
        end
        local u = d[1][0x10b]()
        Y = nil
        local H
        local C
        return C, H, Y, F, h, J, Z, u
    end

    internal_functions.func_Ti = function()
        local J
        local S
        S = J[0x4a8]
        return S
    end

    internal_functions.func_Mi = function(J, C)
        local C = 0x42 + (S.hi((S.Ni(J[0x68e5])), S.l[8], S.l[4]) - J[26313] <= J[78] and J[0x76fb] or J[0x327a])
        J[0x4a8] = C
        return C
    end

    internal_functions.func_Bo = function(J, H)
        H[0x25] = function(...)
            local Z = ({ ... })
            local C = #Z
            if C ~= 0 then
                -- vazio
            else
                return C, Z[1][0xe]
            end
            return C, { ... }
        end
        if not J[27062] then
            H = S:Lo(H, J)
        else
            H = J[0x69b6]
        end
        return
