local compe     = require'compe'
local utils     = require'compe_lbdb.utils'
local blacklist = require'compe_lbdb.blacklist'

------------------
--  query lbdb  --
------------------

-- TODO: this is executed on initial load of vim, need to implement a way of
-- re-querying if data is getting stale in long running sessions
local lbdb_email, lbdb_name = utils.get_contacts(blacklist)
local compe_names    = utils.build_compe_table(lbdb_name, 'name')
local compe_emails   = utils.build_compe_table(lbdb_email, 'email')
local compe_contacts = utils.build_compe_table(lbdb_email, 'mstring')
local full_set       = utils.table_concatenate(compe_names, compe_emails)

--------------------
--  compe source  --
--------------------

local Source = {}

function Source.new()
  return setmetatable({}, {__index = Source })
end

function Source.get_metadata(_)
  return {
    menu = '[lbdb]';
    priority = 100;
    filetypes = {'markdown', 'mail'}
  }
end

function Source.determine(_, context)
  return compe.helper.determine(context)
end

function Source.complete(_, context)
  if utils.in_header() then
    context.callback({
      items = compe_contacts
    })
  else
    context.callback({
      items = full_set
    })
  end
end

compe.register_source('lbdb', Source)
