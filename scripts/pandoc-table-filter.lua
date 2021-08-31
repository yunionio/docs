local system = require 'pandoc.system'

local function starts_with(start, str)
  return str:sub(1, #start) == start
end

local table_html_template = [[
<style>
table {
    font-family: arial, sans-serif;
    border-collapse: collapse;
    width: 100%;
}

td, th {
    border: 1px solid #dddddd;
    text-align: left;
    padding: 8px;
}

tr:nth-child(even) {
    background-color: #dddddd;
}
</style>
]]

local function file_exits(filename)
  local f = io.open(filename, 'r')
  if f ~= nil then
    return true
  end
  return false
end

local function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

local function convert_html_table_to_imgs(text)
  local imgs = {}
  local cp_img = function (tmpdir, src)
    local parts = mysplit(tmpdir, "/")
    local img_parts = mysplit(src, "/")
    local prefix = parts[#parts]
    local img_name = img_parts[#img_parts]
    local out_img = "/tmp/" .. prefix .. "-" .. img_name
    local cp_cmd = "cp " .. src .. " " .. out_img
    os.execute(cp_cmd)
    table.insert(imgs, out_img)
  end
  system.with_temporary_directory('table2image', function (tmpdir)
    system.with_working_directory(tmpdir, function ()
      local f = io.open('table.html', 'w')
      f:write(table_html_template .. text)
      f:close()
      local out_pdf = 'table.pdf'
      local out_png = 'table.png'
      os.execute('wkhtmltopdf --encoding utf-8 table.html ' .. out_pdf)
      os.execute('convert -density 300 -trim ' .. out_pdf .. ' -quality 100 ' .. out_png)
      if file_exits(out_png) then
        cp_img(tmpdir, out_png)
      else
        local idx = 0
        while true do
          local img = 'table-' .. idx .. '.png'
          if file_exits(img) then
            cp_img(tmpdir, img)
            idx = idx + 1
          else
            break
          end
        end
      end
    end)
  end)
  return imgs
end

function RawBlock(el)
  if (el.format ~= "html") then
    return el
  end
  if not starts_with('<table>', el.text) then
    return el
  end
  local imgs = convert_html_table_to_imgs(el.text)
  local elems = {}
  for k, v in ipairs(imgs) do
    table.insert(elems, pandoc.Image({}, v))
  end
  return pandoc.Para(elems)
end
