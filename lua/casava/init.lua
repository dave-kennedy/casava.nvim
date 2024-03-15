local M = {}

function M.align_columns()
    local col_lens = {}
    local num_lines = vim.fn.line('$')
    local num_fields = 0

    for line_num = 1, num_lines, 1 do
        local line = vim.fn.getline(line_num)
        local fields = M.split_fields(line)

        if line_num == 1 then
            num_fields = #fields
        elseif #fields ~= num_fields then
            vim.notify('Column mismatch on line ' .. line_num, vim.log.levels.ERROR)
            return
        end

        for field_num, field in ipairs(fields) do
            local col_len = col_lens[field_num]
            local field_len = #M.trim(field)

            if col_len == nil or col_len < field_len then
                col_lens[field_num] = field_len
            end
        end
    end

    for line_num = 1, num_lines, 1 do
        local line = vim.fn.getline(line_num)
        local new_line = ''
        local fields = M.split_fields(line)

        for field_num, field in ipairs(fields) do
            local col_len = col_lens[field_num]
            local field_len = #M.trim(field)
            local padding = ''

            if col_len > field_len then
                padding = string.rep(' ', col_len - field_len)
            end

            if field_num == num_fields then
                new_line = new_line .. field .. padding
            else
                new_line = new_line .. field .. padding .. ','
            end
        end

        vim.fn.setline(line_num, new_line)
    end
end

function M.find_all(str, pattern)
    local init = 1
    local indices = {}

    while true do
        local start_index, end_index = string.find(str, pattern, init, true)
        if start_index == nil then break end
        table.insert(indices, start_index)
        init = end_index + 1
    end

    return indices
end

function M.is_quoted(quote_indices, delim_index)
    for i = 1, #quote_indices, 2 do
        local quote_start = quote_indices[i]
        local quote_end = quote_indices[i + 1]

        if delim_index > quote_start and delim_index < quote_end then
            return true
        end
    end

    return false
end

function M.split_fields(str)
    local quote_indices = M.find_all(str, '"')
    local delim_indices = M.find_all(str, ',')

    local fields = {}
    local field_start = 1

    for i = 1, #delim_indices + 1 do
        local delim_index = delim_indices[i]

        if not delim_index then
            -- Last field
            local field = M.trim(string.sub(str, field_start))
            table.insert(fields, field)
        elseif M.is_quoted(quote_indices, delim_index) then
            -- Delimiter is between quotes, skip it
        else
            local field_end = delim_index - 1
            local field = M.trim(string.sub(str, field_start, field_end))
            table.insert(fields, field)
            field_start = delim_index + 1
        end
    end

    return fields
end

function M.trim(str)
    return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

function M.setup()
    vim.api.nvim_create_user_command('CsvAlign', function ()
        M.align_columns()
    end, {})
end

return M
