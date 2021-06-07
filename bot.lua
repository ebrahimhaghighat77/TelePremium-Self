
--[[
 _____    _      ____                     _
|_   _|__| | ___|  _ \ _ __ ___ _ __ ___ (_)_   _ _ __ ___
  | |/ _ \ |/ _ \ |_) | '__/ _ \ '_ ` _ \| | | | | '_ ` _ \
  | |  __/ |  __/  __/| | |  __/ | | | | | | |_| | | | | | |
  |_|\___|_|\___|_|   |_|  \___|_| |_| |_|_|\__,_|_| |_| |_|

Developer And Founder : Ebrahim Haghighat (@MrCli)
 Copyright 2021 by TelePremium Team. All Rights Reserved.
]]

---------------------------------------------


_DataConfig = dofile('./Data/DataConfig.lua')
tdbot = require 'tdbot'
serpent = require 'serpent'
json = require 'JSON'
JSON = require "cjson"
redis_ = require "redis"
URL = require "socket.url" 
http = require "socket.http"
https = require "ssl.https"
redis = Redis.connect('127.0.0.1', 6379)
redis:select(_DataConfig.RedisIndex)
MasterId = _DataConfig.Fullsudo
Profile = _DataConfig.ProfileUser
SudoId = _DataConfig.Creator
Sudo = {Creator = SudoId ,SudoUser = MasterId}
SemojeF = {"↫", "⇜", "↜", "⇋", "⇚", "⇠", "⇐"}
SemojeE = {"➟", "➥", "➸","➧", "➲", "➢"}
EemojeF = {"シ "," ♪"," ♯"," ✾"," ♢"," ♤"," ♡"," ♧"}
Emoj = {"❂","⋆","✢","✣","✤","✥","✦","✧","✩","✪","✫","✬","✭","✮","✯","✰","★","✱","✲","✶","✷","✸","✹","✺","✻","✼","❅","❆","❈","❉","❊","❋"}
Dwemoje = {"⇊", "⇓", "⇂","⇃", "⇣", "⇩"}
UserServer = (((io.popen)("whoami")):read("*a")):gsub("\n", "")
PTH = '/home/'..UserServer..''
-------------------------------------------
function sendText(chat_id, reply_to_message_id, text)
tdbot.sendChatAction(chat_id, 'Typing', 10)
  tdbot.sendText(chat_id, reply_to_message_id, text, 0, 1, nil, 1, 'md', 0, nil)
end
function runRequest(req)
	io.popen(req):read("*a")
end

function checkSudo(user, msg)
	math.randomseed(os.time())
	a = math.random(2)
	if a == 1 then
		b = 'مقامش بیشتر از شماست'
	elseif a == 2 then
		b = 'دسترسی بالاتری دارد'
	end
	if user == Sudo.Creator then
		tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' این کاربر '..b, 1, false, nil, 'md')
		return true
	elseif user == Sudo.SudoUser then
		tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' این کاربر '..b, 1, false, nil, 'md')
		return true
	end
	return false
end

function UseMark(text)
	if text then
		str = text
		if str:match('_') then
			output = str:gsub('_',[[\_]])
		elseif str:match('*') then
			output = str:gsub('*','\\*')
		elseif str:match('`') then
			output = str:gsub('`','\\`')
		else
			output = str
		end
	return output
	end
end

local function Scharbytes(s, i)
		local byte    = string.byte
		i = i or 1
		if type(s) ~= "string" then
		end
		if type(i) ~= "number" then
		end
		local c = byte(s, i)
		if c > 0 and c <= 127 then
			return 1
		elseif c >= 194 and c <= 223 then
			local c2 = byte(s, i + 1)
			if not c2 then
			end
			if c2 < 128 or c2 > 191 then
			end
			return 2
		elseif c >= 224 and c <= 239 then
			local c2 = byte(s, i + 1)
			local c3 = byte(s, i + 2)
			if not c2 or not c3 then
			end
			if c == 224 and (c2 < 160 or c2 > 191) then
			elseif c == 237 and (c2 < 128 or c2 > 159) then
			elseif c2 < 128 or c2 > 191 then
			end
			if c3 < 128 or c3 > 191 then
			end
			return 3
		elseif c >= 240 and c <= 244 then
			local c2 = byte(s, i + 1)
			local c3 = byte(s, i + 2)
			local c4 = byte(s, i + 3)
			if not c2 or not c3 or not c4 then
			end
			if c == 240 and (c2 < 144 or c2 > 191) then
			elseif c == 244 and (c2 < 128 or c2 > 143) then
			elseif c2 < 128 or c2 > 191 then
			end
			if c3 < 128 or c3 > 191 then
			end
			if c4 < 128 or c4 > 191 then
			end
			return 4
		else
		end
end
	
function string:split(sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

local function slen(s)
	if type(s) ~= "string" then
		for k,v in pairs(s) do print('"',tostring(k),'"',tostring(v),'"') end
	end
	local pos = 1
	local bytes = string.len(s)
	local length = 0
	while pos <= bytes do
		length = length + 1
		pos = pos + Scharbytes(s, pos)
	end
	return length
end

local function vardump(value)
	print(serpent.block(value, {comment=false}))
end

function msg_valid(msg)
	local msg_time = os.time() - 60
	if msg.date < tonumber(msg_time) then
		return false
	end
    return true
end

local function CleanMsg(msg)
	function CallBack(arg, data)
		if data.messages then
			for k,v in pairs(data.messages) do
				tdbot.deleteMessagesFromUser(v.chat_id, v.sender_user_id)
			end
		end
		if data.messages[0] then
			tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0, 100, false, CallBack)
		end
	end
	tdbot.getChatHistory(msg.chat_id, msg.id, 0, 100, false, CallBack)
end

function sendMetion(chat_id, user_id, msg_id, text)
	function dl_cb(a, d)
	end
	length = tonumber(slen(tostring(text)))
	assert (tdbot_function ({
    _ = "sendMessage",
    chat_id = chat_id,
    reply_to_message_id = msg_id,
    disable_notification = 0,
    from_background = true,
    reply_markup = nil,
    input_message_content = {
      _ = "inputMessageText",
      text = text,
      disable_web_page_preview = 1,
      clear_draft = false,
      entities = {[0] = {
      offset =  0,
      length = length,
      _ = "textEntity",
      type = {user_id = user_id, _ = "textEntityTypeMentionName"}}}
    }
  }, dl_cb, nil))
end

function User_Enemy(msg)
local hash =  redis:sismember(Profile..'EnemyUser',msg.sender_user_id)
if hash then
return true
else
return false
end
end

local function SendAlarm(msg,user,text)
	function callback2(arg, data)
		tdbot.openChat(data.id)
		sendText(data.id, 0, text) 
	end
		function callback(arg, data)
			if data.username ~= '' then tdbot.searchPublicChat(data.username, callback2)
			else
				callback2(nil, {id=user})
			end
		end
	tdbot.getUser(user, callback)
end
-----------------------------------------------------
function tdbot_update_callback (data)
	if data.message and data.message.send_state and data.message.send_state._ == 'messageIsSuccessfullySent' then
		local msg = data.message
		if redis:get(Profile..'SelfExpire') then
		if msg_valid(msg) then
			id = tostring(msg.chat_id)
			if id:match("-100") then
			grouptype = "supergroup"
			if not redis:sismember(Profile.."SuperGroup:", msg.chat_id) then
			redis:sadd(Profile.."SuperGroup:",msg.chat_id)
			end
			elseif id:match("-") then
			grouptype = "group"
			if not redis:sismember(Profile.."Group:", msg.chat_id) then
			redis:sadd(Profile.."Group:",msg.chat_id)
			end
			elseif id:match("") then
			grouptype = "pv"
			if not redis:sismember(Profile.."Prvite:", msg.chat_id) then
			redis:sadd(Profile.."Prvite:",msg.chat_id)
			end
			end
			if tostring(msg.chat_id):match('^-100') then
			ChatType = 'channel'
			elseif tostring(msg.chat_id):match('^-') then
			ChatType = 'chat'
			else
			ChatType = 'pv'
			end
			redis:incr(Profile.."AllMsgYou")
			if msg.reply_to_message_id ~= 0 then
				Msg_Reply = msg.reply_to_message_id
			else
				Msg_Reply = false
			end
			STRE = SemojeE[(math.random)(#SemojeE)]
			E = EemojeF[(math.random)(#EemojeF)]
			STR = SemojeF[(math.random)(#SemojeF)]
			J = Emoj[(math.random)(#Emoj)]
			if msg.content._ == 'messageText' then
				Majhol_Self = msg.content.text
				if Majhol_Self then
				Majhol_Self = Majhol_Self:lower()
				end
				if Majhol_Self:match('^[/#!~^]') then
				Majhol_Self = Majhol_Self:gsub('^[/#!~^]','')
				end
				if (Majhol_Self:match('^اعتبار (%d+)$') or Majhol_Self:match('^expire (%d+)$')) and msg.sender_user_id == SudoId then
					Expire = tonumber(msg.content.text:match('(%d+)$')) * 86400
					Time = math.floor(Expire / 86400 )
					redis:setex(Profile..'SelfExpire',Expire,true)
					redis:del(Profile..'SelfExpireEnd')
					sendText(msg.chat_id, msg.id, STR..' شارژ اکانت *'..Profile..'* به `'..Time..'` روز تنظیم شد')
				end
				if (Majhol_Self:match('^+اعتبار (%d+)$') or Majhol_Self:match('^+expire (%d+)$')) and msg.sender_user_id == SudoId then
					Expire = tonumber(msg.content.text:match('(%d+)$')) * 86400
					OldTime = redis:ttl(Profile..'SelfExpire')
					TimeOld = math.floor(OldTime / 86400 )
					NewTime = math.floor(Expire / 86400 )
					TimeNew = math.floor((Expire + OldTime) / 86400 )
					redis:setex(Profile..'SelfExpire',Expire + OldTime,true)
					sendText(msg.chat_id, msg.id, STR..' شارژ اکانت *'..Profile..'* تغییر کرد به '..TimeNew..' روز مقدار شارژ اضافه شده '..NewTime..' روز شارژ قبلی '..TimeOld..' روز')
				end
				if Majhol_Self:match('^سلف (.*)$') or Majhol_Self:match('^self (.*)$') then
					matches = {string.match(Majhol_Self, '^(.*) (.*)$')}
					if matches[2]:match('^on$') or matches[2]:match('^روشن$') then
						redis:del(Profile..'Self:')
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' سلف بات شما روشن شد', 1, false, nil, 'md')
					elseif matches[2]:match('^off$') or matches[2]:match('^خاموش$') then
						redis:set(Profile..'Self:', true)
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' سلف بات شما خاموش شد', 1, false, nil, 'md')
					end
				end
				if not redis:get(Profile..'Self:') then
					if Majhol_Self:match('^منشی (.*)$') or Majhol_Self:match('^monshi (.*)$') and tonumber(msg.reply_to_message_id) == 0 then
						monshi = msg.content.text:match('^monshi (.*)$') or msg.content.text:match('^منشی (.*)$')
						if monshi:match('^off$') or monshi:match('^خاموش$') then
							tdbot.editMessageText(msg.chat_id, msg.id, nil,STR..' منشی اکانت شما خاموش شد', 1, false, nil, 'md')
							redis:del(Profile..'SetMonshi')
							redis:del(Profile..'MonshiMode')
							redis:del(Profile..'MonshiMode')
							redis:del(Profile..'MonshiFile')
						else
							redis:set(Profile..'SetMonshi', monshi)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' منشی اکانت شما فعال شد و متن زیر به عنوان متن منشی ذخیره شد :\n'..UseMark(monshi), 1, false, nil, 'md')
						end
					end
					if (Majhol_Self:match('^monshi (.*)$') or Majhol_Self:match('^منشی (.*)$')) and Msg_Reply then
						Caption = msg.content.text:match('^monshi (.*)$') or msg.content.text:match('^منشی (.*)$')
						function CallBack(arg, data)
							if data.content._ == 'messageVoice' then
								redis:set(Profile..'SetMonshi', Caption)
								redis:set(Profile..'MonshiMode', 'Voice')
								redis:set(Profile..'MonshiFile', data.content.voice.voice.persistent_id)
								tdbot.deleteMessages(msg.chat_id, msg.id, true)
								tdbot.editMessageCaption(msg.chat_id, Msg_Reply, nil, STR..' این ویس به عنوان منشی ذخیره شد با کپشن :\n'..UseMark(Caption))
							else
								tdbot.editMessageCaption(msg.chat_id, Msg_Reply, nil, STR..' مشکل در فایل ارسالی لطفا برسی کنید که فایل حتما به صورت ویس باشد')
							end
						end
						tdbot.getMessage(msg.chat_id, tonumber(Msg_Reply), CallBack)
					end
					if (Majhol_Self:match('^savemedia (.*)$') or Majhol_Self:match('^ذخیره رسانه (.*)$')) and Msg_Reply then
						Name = Majhol_Self:match('^savemedia (.*)$') or Majhol_Self:match('^ذخیره رسانه (.*)$')
						function CallBack(arg, data)
							if redis:sismember(Profile..'Medias',Name) then
							tdbot.deleteMessages(msg.chat_id, msg.id, true)
							sendText(msg.chat_id, Msg_Reply, STR..' رسانه ای با همین نام ذخیره شده است\nلطفا نام دیگری انتخاب کنید')
							else
								if data.content._ == 'messagePhoto' then
									redis:set(Profile..'Media'..Name, data.content.photo.sizes[0].photo.persistent_id)
									redis:sadd(Profile..'Medias',Name) 
									redis:set(Profile..'FileMode'..Name, 'Photo')
									tdbot.deleteMessages(msg.chat_id, msg.id, true)
									sendText(msg.chat_id, Msg_Reply, STR..'عکس با نام `'..Name..'` ذخیره شد\n'..J..' جهت ارسال دستور \n'..J..' ارسال رسانه `'..Name..'` را ارسال کنید\n')
								elseif data.content._ == 'messageAnimation' then
									redis:set(Profile..'Media'..Name, data.content.animation.animation.persistent_id)
									redis:sadd(Profile..'Medias',Name)
									redis:set(Profile..'FileMode'..Name, 'Animation')
									tdbot.deleteMessages(msg.chat_id, msg.id, true)
									sendText(msg.chat_id, Msg_Reply, STR..'گیف با نام `'..Name..'` ذخیره شد\n'..J..' جهت ارسال دستور \n'..J..' ارسال رسانه `'..Name..'` را ارسال کنید\n')
								elseif data.content._ == 'messageVoice' then
									redis:set(Profile..'Media'..Name, data.content.voice.voice.persistent_id)
									redis:sadd(Profile..'Medias',Name)
									redis:set(Profile..'FileMode'..Name, 'Voice')
									tdbot.deleteMessages(msg.chat_id, msg.id, true)
									sendText(msg.chat_id, Msg_Reply, STR..'ویسی با نام `'..Name..'` ذخیره شد\n'..J..' جهت ارسال دستور \n'..J..' ارسال رسانه `'..Name..'` را ارسال کنید\n')
								elseif data.content._ == 'messageDocument' then
									redis:set(Profile..'Media'..Name, data.content.document.document.persistent_id)
									redis:sadd(Profile..'Medias',Name)
									redis:set(Profile..'FileMode'..Name, 'Document')
									tdbot.deleteMessages(msg.chat_id, msg.id, true)
									sendText(msg.chat_id, Msg_Reply, STR..'فایلی با نام `'..Name..'` ذخیره شد\n'..J..' جهت ارسال دستور \n'..J..' ارسال رسانه `'..Name..'` را ارسال کنید\n')
								elseif data.content._ == 'messageVideo' then
									redis:set(Profile..'Media'..Name, data.content.video.video.persistent_id)
									redis:sadd(Profile..'Medias',Name)
									redis:set(Profile..'FileMode'..Name, 'Video')
									tdbot.deleteMessages(msg.chat_id, msg.id, true)
									sendText(msg.chat_id, Msg_Reply, STR..'فیلمی با نام `'..Name..'` ذخیره شد\n'..J..' جهت ارسال دستور \n'..J..' ارسال رسانه `'..Name..'` را ارسال کنید\n')
								elseif data.content._ == 'messageAudio' then
									redis:set(Profile..'Media'..Name, data.content.audio.audio.id)
									redis:sadd(Profile..'Medias',Name)
									redis:set(Profile..'FileMode'..Name, 'Audio')
									tdbot.deleteMessages(msg.chat_id, msg.id, true)
									sendText(msg.chat_id, Msg_Reply, STR..'آهنگی با نام `'..Name..'` ذخیره شد\n'..J..' جهت ارسال دستور \n'..J..' ارسال رسانه `'..Name..'` را ارسال کنید\n')
								elseif data.content._ == 'messageVideoNote' then
									redis:set(Profile..'Media'..Name, data.content.video_note.video.persistent_id)
									redis:sadd(Profile..'Medias',Name)
									redis:set(Profile..'FileMode'..Name, 'VideoNote')
									tdbot.deleteMessages(msg.chat_id, msg.id, true)
									sendText(msg.chat_id, Msg_Reply, STR..'سلفی با نام `'..Name..'` ذخیره شد\n'..J..' جهت ارسال دستور \n'..J..' ارسال رسانه `'..Name..'` را ارسال کنید\n')
								elseif data.content._ == 'messageContact' then
									redis:set(Profile..'Media'..Name, data.content.contact.phone_number)
									redis:sadd(Profile..'Medias',Name)
									redis:set(Profile..'FileMode'..Name, 'Contact')
									tdbot.deleteMessages(msg.chat_id, msg.id, true)
									sendText(msg.chat_id, Msg_Reply, STR..'مخاطبی با نام `'..Name..'` ذخیره شد\n'..J..' جهت ارسال دستور \n'..J..' ارسال رسانه `'..Name..'` را ارسال کنید\n')
								elseif data.content._ == 'messageSticker' then
									redis:set(Profile..'Media'..Name, data.content.sticker.sticker.id)
									redis:sadd(Profile..'Medias',Name)
									redis:set(Profile..'FileMode'..Name, 'Sticker')
									tdbot.deleteMessages(msg.chat_id, msg.id, true)
									sendText(msg.chat_id, Msg_Reply, STR..'استیکری با نام `'..Name..'` ذخیره شد\n'..J..' جهت ارسال دستور \n'..J..' ارسال رسانه `'..Name..'` را ارسال کنید\n')
								end
							end
						end
						tdbot.getMessage(msg.chat_id, tonumber(Msg_Reply), CallBack)
					end
					if (Majhol_Self:match('^sendmedia (.*)$') or Majhol_Self:match('^ارسال رسانه (.*)$')) then
						Name = Majhol_Self:match('^sendmedia (.*)$') or Majhol_Self:match('^ارسال رسانه (.*)$')
						Mode = redis:get(Profile..'FileMode'..Name)
						ID = redis:get(Profile..'Media'..Name)
						if redis:sismember(Profile..'Medias',Name) then
							if Mode == 'Photo' then
								tdbot.deleteMessages(msg.chat_id, msg.id, true)
								tdbot.sendPhoto(msg.chat_id, msg.id, ID, nil, 0, 0, '', 0, 0, 1, nil)
							 elseif Mode == 'Animation' then
								tdbot.deleteMessages(msg.chat_id, msg.id, true)
								tdbot.sendDocument(msg.chat_id, ID, '', nil, msg.id, 0, 1, nil, dl_cb, nil)
							elseif Mode == 'Voice' then
								tdbot.deleteMessages(msg.chat_id, msg.id, true)
								tdbot.sendDocument(msg.chat_id, ID, '', nil, msg.id, 0, 1, nil, dl_cb, nil)
							elseif Mode == 'Document' then
								tdbot.deleteMessages(msg.chat_id, msg.id, true)
								tdbot.sendDocument(msg.chat_id, ID, '', nil, msg.id, 0, 1, nil, dl_cb, nil)
							elseif Mode == 'Video' then
								tdbot.deleteMessages(msg.chat_id, msg.id, true)
								tdbot.sendVideo(msg.chat_id,msg.id, ID,nil,0 ,0, 0, '',0,0,1, nil)
							elseif Mode == 'Audio' then
								tdbot.deleteMessages(msg.chat_id, msg.id, true)
								tdbot.sendAudio(msg.chat_id, msg.id, ID, 0, 0, 0, '', 0, 1, nil)
							elseif Mode == 'VideoNote' then
								tdbot.deleteMessages(msg.chat_id, msg.id, true)
								tdbot.sendVideoNote(msg.chat_id, msg.id, ID, nil, 0, 0, 0, 1, nil)
							elseif Mode == 'Contact' then
								tdbot.deleteMessages(msg.chat_id, msg.id, true)
								tdbot.sendContact(msg.chat_id, msg.id, ID, Name, '', 0, 0, 1, nil)
							elseif Mode == 'Sticker' then
								tdbot.deleteMessages(msg.chat_id, msg.id, true)
								tdbot.sendSticker(msg.chat_id, msg.id, ID, 0, 0, 0, 1, nil)
							end
						else
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' فایلی با این نام ذخیره نشده است', 1, false, nil, 'md')
						end
					end
					if (Majhol_Self:match('^delmedia (.*)$') or Majhol_Self:match('^حذف رسانه (.*)$')) then
						Name = Majhol_Self:match('^delmedia (.*)$') or Majhol_Self:match('^حذف رسانه (.*)$')
						if redis:sismember(Profile..'Medias',Name) then
							redis:del(Profile..'Media'..Name)
							redis:srem(Profile..'Medias',Name)
							redis:del(Profile..'FileMode'..Name)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' با موفقیت پاک شد', 1, false, nil, 'md')
						else
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' فایلی با این نام ذخیره نشده است', 1, false, nil, 'md')
						end
					end
					if (Majhol_Self:match('^media list$') or Majhol_Self:match('^لیست رسانه ها$')) then
						 list = redis:smembers(Profile..'Medias')
						 text = J..' لیست رسانه های ذخیره شده :\n\n'
						 for k,v in pairs(list) do 
							Mode = redis:get(Profile..'FileMode'..v)
							if Mode == 'Photo' then
								Type = 'عکس'
							elseif Mode == 'Animation' then
								Type = 'گیف'
							elseif Mode == 'Voice' then
								Type = 'ویس'
							elseif Mode == 'Document' then
								Type = 'فایل'
							elseif Mode == 'Video' then
								Type = 'فیلم'
							elseif Mode == 'Audio' then
								Type = 'آهنگ'
							elseif Mode == 'VideoNote' then
								Type = 'سلفی'
							elseif Mode == 'Contact' then
								Type = 'مخاطب'
							elseif Mode == 'Sticker' then
								Type = 'استیکر'
							end
						  text = text..''..STR..' `'..UseMark(v)..'` - *'..Type..'*\n'
						 end
						 if #list == 0 then
						 text = STR..' لیست ذخیره ها خالی میباشد'
						 end
						 tdbot.editMessageText(msg.chat_id, msg.id, nil, text, 1, false, nil, 'md')
					end
					if ChatType == 'channel' then
					if Majhol_Self:match('^دعوت$') or Majhol_Self:match('^invite$') and Msg_Reply then
						function InviteByReply(Majhol,Premium)
							tdbot.addChatMembers(msg.chat_id,Premium.sender_user_id)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' کاربر `'..Premium.sender_user_id..'` با موفقیت به گروه دعوت شد', 1, false, nil, 'md')
						end
						tdbot.getMessage(msg.chat_id, tonumber(Msg_Reply), InviteByReply)
					end
					if Majhol_Self:match('^دعوت (%d+)$') or Majhol_Self:match('^invite (%d+)$') then
						matches = {string.match(Majhol_Self, '^(.*) (%d+)$')}
						tdbot.addChatMembers(msg.chat_id,matches[2])
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' کاربر `'..matches[2]..'` با موفقیت به گروه دعوت شد', 1, false, nil, 'md')
					end
					if Majhol_Self:match('^دعوت (.*)$') or Majhol_Self:match('^invite (.*)$') then
						matches = {string.match(Majhol_Self, '^(.*) (.*)$')}
						function InviteByUserName(Majhol,Premium)
							if Premium.id then
								tdbot.addChatMembers(msg.chat_id,Premium.id)
								tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' کاربر `'..Premium.id..'` با موفقیت به گروه دعوت شد', 1, false, nil, 'md')
							end
						end
						tdbot.searchPublicChat(matches[2], InviteByUserName)
					end
					if (Majhol_Self:match('^قفل گروه$') or Majhol_Self:match('^lock gp$') or Majhol_Self:match('^lockgp$')) then
						if not redis:sismember(Profile..'SelfGpLock', msg.chat_id) then
							redis:sadd(Profile..'SelfGpLock', msg.chat_id)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' گروه قفل شد', 1, false, nil, 'md')
						else
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' گروه از قبل قفل بود', 1, false, nil, 'md')
						end
					end
					if (Majhol_Self:match('^بازکردن گروه$') or Majhol_Self:match('^باز کردن گروه$') or Majhol_Self:match('^unlock gp$') or Majhol_Self:match('^unlockgp$')) then
						if redis:sismember(Profile..'SelfGpLock', msg.chat_id) then
							redis:srem(Profile..'SelfGpLock', msg.chat_id)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' قفل گروه باز شد', 1, false, nil, 'md')
						else
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' گروه قفل نبود', 1, false, nil, 'md')
						end
					end
					if (Majhol_Self:match('^pin$') or Majhol_Self:match('^پین$') or Majhol_Self:match('^سنجاق$')) and Msg_Reply then
						tdbot.pinChannelMessage(msg.chat_id, Msg_Reply, 0)
					end
					if (Majhol_Self:match('^unpin$') or Majhol_Self:match('^آنپین$') or Majhol_Self:match('^انپین$') or Majhol_Self:match('^برداشتن سنجاق$')) then
						tdbot.deleteMessages(msg.chat_id, msg.id)
						tdbot.unpinChannelMessage(msg.chat_id)
					end
					if Majhol_Self:match('^اسم گروه (.*)$') or Majhol_Self:match('^gpname (.*)$') then
						matchesFA = {string.match(msg.content.text, '^اسم گروه (.*)$')}
						matchesEN = {string.match(msg.content.text, '^gpname (.*)$')}
						Title = matchesEN[1] or matchesFA[1]
						tdbot.changeChatTitle(msg.chat_id, UseMark(Title))
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' اسم گروه تغییر کرد به : '..UseMark(Title), 1, false, nil, 'md')
					end
					if Majhol_Self:match('^درباره گروه (.*)$') or Majhol_Self:match('^gptitle (.*)$') then
						matchesFA = {string.match(msg.content.text, '^درباره گروه (.*)$')}
						matchesEN = {string.match(msg.content.text, '^gptitle (.*)$')}
						Title = matchesEN[1] or matchesFA[1]
						tdbot.changeChannelDescription(msg.chat_id, UseMark(Title))
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' درباره گروه تغییر کرد به : '..UseMark(Title), 1, false, nil, 'md')
					end
					if (Majhol_Self:match('^clean msg$') or Majhol_Self:match('^پاکسازی پیام ها$')) then
						tdbot.deleteMessages(msg.chat_id, msg.id)
						CleanMsg(msg)
					end
					if (Majhol_Self:match('^حذف$') or Majhol_Self:match('^del$')) and Msg_Reply then
						tdbot.deleteMessages(msg.chat_id, msg.id, true)
						tdbot.deleteMessages(msg.chat_id, Msg_Reply)
					end
					end
					if Majhol_Self:match('^مسدود$') or Majhol_Self:match('^block$') then
						if Msg_Reply then
							function BlockByReply(Majhol,Premium)
								if Premium.sender_user_id and Premium.sender_user_id ~= Premium.sender_user_id then
									if checkSudo(Premium.sender_user_id, msg) then return false end
									tdbot.blockUser(Premium.sender_user_id)
									tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' کاربر `'..Premium.sender_user_id..'` مسدود شد', 1, false, nil, 'md')
								end
							end
							tdbot.getMessage(msg.chat_id, tonumber(Msg_Reply), BlockByReply)
						elseif not Msg_Reply and ChatType == 'pv' then
							if checkSudo(msg.chat_id, msg) then return false end
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' مسدود شدی', 1, false, nil, 'md')
							tdbot.blockUser(msg.chat_id)
						end
					end
					if Majhol_Self:match('^مسدود (%d+)$') or Majhol_Self:match('^block (%d+)$') then
						matches = {string.match(Majhol_Self, '^(.*) (%d+)$')}
						if checkSudo(matches[2], msg) then return false end
						tdbot.blockUser(matches[2])
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' کاربر `'..matches[2]..'` مسدود شد', 1, false, nil, 'md')
					end
					if Majhol_Self:match('^مسدود (.*)$') or Majhol_Self:match('^block (.*)$') then
						matches = {string.match(Majhol_Self, '^(.*) (.*)$')}
						function BlockByUserName(Majhol,Premium)
							if Premium.id then
							if checkSudo(Premium.id, msg) then return false end
								tdbot.blockUser(Premium.id)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' کاربر `'..Premium.id..'` مسدود شد', 1, false, nil, 'md')
							end
						end
						tdbot.searchPublicChat(matches[2], BlockByUserName)
					end
					if Majhol_Self:match('^حذف مسدود$') or Majhol_Self:match('^unblock$') and Msg_Reply then
						function BlockByReply(Majhol,Premium)
							if checkSudo(Premium.sender_user_id, msg) then return false end
							tdbot.unblockUser(Premium.sender_user_id)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' کاربر `'..Premium.sender_user_id..'` حذف مسدود شد', 1, false, nil, 'md')
						end
						tdbot.getMessage(msg.chat_id, tonumber(Msg_Reply), BlockByReply)
					end
					if Majhol_Self:match('^حذف مسدود (%d+)$') or Majhol_Self:match('^unblock (%d+)$') then
						matches = {string.match(Majhol_Self, '^(.*) (%d+)$')}
						if checkSudo(matches[2], msg) then return false end
						tdbot.unblockUser(matches[2])
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' کاربر `'..matches[2]..'` حذف مسدود شد', 1, false, nil, 'md')
					end
					if Majhol_Self:match('^حذف مسدود (.*)$') or Majhol_Self:match('^unblock (.*)$') then
						matchesFA = {string.match(Majhol_Self, '^حذف بلاک (.*)$')}
						matchesEN = {string.match(Majhol_Self, '^unblock (.*)$')}
						username = matchesEN[1] or matchesFA[1]
						function BlockByUserName(Majhol,Premium)
							if Premium.id then
							if checkSudo(Premium.id, msg) then return false end
								tdbot.unblockUser(Premium.id)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' کاربر `'..Premium.id..'` حذف مسدود شد', 1, false, nil, 'md')
							end
						end
						tdbot.searchPublicChat(username, BlockByUserName)
					end
					if Majhol_Self:match('^تیک (.*)$') or Majhol_Self:match('^markread (.*)$') then
						matches = {string.match(Majhol_Self, '^(.*) (.*)$')}
						function GetFchat(arg, result)
							ChatName = result.title
							function GetUsername(arg, result)
							  if result.first_name ~= '' then
									Fname = result.first_name
									else
									Fname = "ندارد"
									end
						if matches[2]:match('^all$') or matches[2]:match('^همه$') then
							redis:set(Profile..'MarkReadChat', 'All')
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های گروها و پیوی ها فعال شد', 1, false, nil, 'md')
						elseif matches[2]:match('^off$') or matches[2]:match('^خاموش$') then
							if redis:get(Profile..'MarkReadChat'..msg.chat_id) then
								redis:del(Profile..'MarkReadChat'..msg.chat_id)
								redis:srem(Profile.."MarkReadChatHere",msg.chat_id)
								redis:del(Profile.."MarkReadGpHere"..msg.chat_id)
								tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های این گفت و گو غیرفعال شد', 1, false, nil, 'md')
							else
								redis:del(Profile..'MarkReadChat')
								tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های گروها و پیوی ها غیرفعال شد', 1, false, nil, 'md')
							end
						elseif matches[2]:match('^pv$') or matches[2]:match('^پیوی$') then
							redis:set(Profile..'MarkReadChat', 'Prvite')
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های پیوی ها روشن شد', 1, false, nil, 'md')
						elseif matches[2]:match('^group$') or matches[2]:match('^گروه$') then
							redis:set(Profile..'MarkReadChat', 'Groups')
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های گروه ها فعال شد', 1, false, nil, 'md')
						elseif matches[2]:match('^here$') or matches[2]:match('^اینجا$') then
							redis:set(Profile..'MarkReadChat'..msg.chat_id, true)
							redis:sadd(Profile.."MarkReadChatHere",msg.chat_id)
							if ChatType == 'channel' then
							redis:set(Profile.."MarkReadGpHere"..msg.chat_id,ChatName)
							elseif ChatType == 'pv' then
							redis:set(Profile.."MarkReadGpHere"..msg.chat_id,Fname)
							else
							redis:set(Profile.."MarkReadGpHere"..msg.chat_id,ChatName)
							end
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های این گفت و گو فعال شد', 1, false, nil, 'md')
						end
						end
			tdbot.getUser(msg.chat_id,GetUsername)
						end
					tdbot.getChat(msg.chat_id,GetFchat)
					end
					if Majhol_Self:match('^تیک$') or Majhol_Self:match('^markread$') and Msg_Reply then
						function MarkreadByReply(Majhol,Premium)
							if redis:sismember(Profile.."MarkReadChatHere",Premium.sender_user_id) then
								redis:srem(Profile.."MarkReadChatHere",Premium.sender_user_id)
								redis:del(Profile.."MarkReadGpHere"..Premium.sender_user_id)
								redis:del(Profile..'MarkReadChat'..Premium.sender_user_id)
								tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های `'..Premium.sender_user_id..'` غیرفعال شد', 1, false, nil, 'md')
							else
								redis:set(Profile..'MarkReadChat'..Premium.sender_user_id, true)
								redis:sadd(Profile.."MarkReadChatHere",Premium.sender_user_id)
								tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های `'..Premium.sender_user_id..'` فعال شد', 1, false, nil, 'md')
								function GetUsername(arg, result)
									if result.first_name ~= '' then
										Fname = result.first_name
									else
										Fname = "ندارد"
									end
									redis:set(Profile.."MarkReadGpHere"..Premium.sender_user_id,Fname)
								end
								tdbot.getUser(Premium.sender_user_id, GetUsername)
							end
						end
						tdbot.getMessage(msg.chat_id, tonumber(Msg_Reply), MarkreadByReply)
					end
					if Majhol_Self:match('^تیک (-100)(%d+)$') or Majhol_Self:match('^markread (-100)(%d+)$') then
						Id = Majhol_Self:match('^تیک (.*)$') or Majhol_Self:match('^markread (.*)$')
						if redis:sismember(Profile.."MarkReadChatHere",Id) then
							redis:srem(Profile.."MarkReadChatHere",Id)
							redis:del(Profile.."MarkReadGpHere"..Id)
							redis:del(Profile..'MarkReadChat'..Id)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های `'..Id..'` غیرفعال شد', 1, false, nil, 'md')
						else
							redis:set(Profile..'MarkReadChat'..Id, true)
							redis:sadd(Profile.."MarkReadChatHere",Id)
							function GetFchat(arg, result)
								ChatName = result.title
								redis:set(Profile.."MarkReadGpHere"..Id,ChatName or '')
							end
							tdbot.getChat(Id,GetFchat)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های `'..Id..'` فعال شد', 1, false, nil, 'md')
						end
					end
					if Majhol_Self:match('^تیک (%d+)$') or Majhol_Self:match('^markread (%d+)$') then
						Id = Majhol_Self:match('^تیک (.*)$') or Majhol_Self:match('^markread (.*)$')
						if redis:sismember(Profile.."MarkReadChatHere",Id) then
							redis:srem(Profile.."MarkReadChatHere",Id)
							redis:del(Profile.."MarkReadGpHere"..Id)
							redis:del(Profile..'MarkReadChat'..Id)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های `'..Id..'` غیرفعال شد', 1, false, nil, 'md')
						else
							redis:set(Profile..'MarkReadChat'..Id, true)
							redis:sadd(Profile.."MarkReadChatHere",Id)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های  `'..Id..'` فعال شد', 1, false, nil, 'md')
							function GetUsername(arg, result)
									if result.first_name ~= '' then
									Fname = result.first_name
									else
									Fname = "ندارد"
									end
								redis:set(Profile.."MarkReadGpHere"..Id,Fname or '')
							end
							tdbot.getUser(Id,GetUsername)
						end
					end
					if Majhol_Self:match('^تیک (.*)$') or Majhol_Self:match('^markread (.*)$') then
						matches = {string.match(Majhol_Self, '^(.*) (.*)$')}
						function UserName(Majhol,Premium)
							if Premium.id and Premium.id ~= "-100(%d+)" then
								if redis:sismember(Profile.."MarkReadChatHere",Premium.id) then
									redis:srem(Profile.."MarkReadChatHere",Premium.id)
									redis:del(Profile.."MarkReadGpHere"..Premium.id)
									redis:del(Profile..'MarkReadChat'..Premium.id)
									tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های `'..Premium.id..'` غیرفعال شد', 1, false, nil, 'md')
								else
									redis:set(Profile..'MarkReadChat'..Premium.id, true)
									redis:sadd(Profile.."MarkReadChatHere",Premium.id)
									tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' خواندن تمام پیام های `'..Premium.id..'` فعال شد', 1, false, nil, 'md')
									local function GetUsername(a, r)
										if r.first_name ~= '' then
										Fname = r.first_name
										else
										Fname = "ندارد"
										end
										redis:set(Profile.."MarkReadGpHere"..Premium.id,Fname or '')
									end
									tdbot.getUser(Premium.id, GetUsername)
								end
							end
						end
						tdbot.searchPublicChat(matches[2], UserName)
					end
					if Majhol_Self:match('^وضعیت خواندن پیام$') or Majhol_Self:match('^markread status$') then
						if redis:get(Profile..'MarkReadChat') == 'All' then
							MarkReadStatus = 'همه'
						elseif redis:get(Profile..'MarkReadChat') == 'Groups' then
							MarkReadStatus = 'گروه ها'
						elseif redis:get(Profile..'MarkReadChat') == 'Prvite' then
							MarkReadStatus = 'پیوی ها'
						else
							MarkReadStatus = 'خاموش'
						end
						if redis:get(Profile..'MarkReadChat'..msg.chat_id) then
							MarkreadHere = 'روشن'
						else
							MarkreadHere = 'خاموش'
						end
						ChatMarkread = tostring(redis:scard(Profile..'MarkReadChatHere') or 0)
						list = redis:smembers(Profile..'MarkReadChatHere')
						text = J..' لیست چت های تیک خورده :\n\n'
						if #list ~= 0 then
							for k,v in pairs(list) do
							Name = redis:get(Profile.."MarkReadGpHere"..v) or ''
								text = text..''..STR..' '..k..'\nشناسه : `'..v..'`\n'..J..' نام : *'..UseMark(Name)..'*\n'
							end
						else
							text = ''
						end
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' وضعیت کلی خواندن پیام : '..MarkReadStatus..'\nوضعیت خواندن پیام این گفت و گو : '..MarkreadHere..'\nتعداد گفت و گو های تیک خورده : '..ChatMarkread..'\n\n'..text, 1, false, nil, 'md')
					end
					if Majhol_Self:match('^پاکسازی لیست خواندن پیام$') or Majhol_Self:match('^clean markread list$') then
					list = redis:smembers(Profile..'MarkReadChatHere')
						for k,v in pairs(list) do
								redis:del(Profile..'MarkReadChat'..v)
								redis:del(Profile.."MarkReadGpHere"..v)
							end
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' تمام گفت و گو های تیک خورده پاکسازی شدند', 1, false, nil, 'md')
						function alarm(arg, data)
						redis:del(Profile..'MarkReadChatHere')
						end
						tdbot.setAlarm(5, alarm)
					end
					if Majhol_Self:match('^پاسخ (.*)$') or Majhol_Self:match('^answer (.*)$') then
						matches = {string.match(Majhol_Self, '^(.*) (.*)$')}
						if matches[2]:match('^on$') or matches[2]:match('^روشن$') then
							redis:del(Profile..'Answer:')
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' حالت پاسخ خودکار روشن شد', 1, false, nil, 'md')
						elseif matches[2]:match('^off$') or matches[2]:match('^خاموش$') then
							redis:set(Profile..'Answer:', true)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' حالت پاسخ خودکار خاموش شد', 1, false, nil, 'md')
						end
					end
					if Majhol_Self:match('^بروزرسانی$') or Majhol_Self:match('^reload$') then
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR.." سلف شما با موفقیت به روزرسانی شد", 1, false, nil, 'md')
						dofile('./bot.lua')
					end
					if Majhol_Self:match('^ایدی$') or Majhol_Self:match('^id$') and Msg_Reply then
						function InfoByReply(Majhol,Premium)
							if Premium.sender_user_id then
								local function GetUsername(a, r)
								function GetFull(extra, result)
									if r.username ~= '' then
									UsrNm = '@'..r.username
									else
									UsrNm = 'ندارد'
									end
									if r.first_name ~= '' then
									Fname = r.first_name
									else
									Fname = "ندارد"
									end
									if result.about then
									Bio = result.about
									else  
									Bio = 'ندارد'
									end
									if result.common_chat_count  then
									common_chat_count  = result.common_chat_count 
									else 
									common_chat_count  = 'ندارد'
									end
								tdbot.editMessageText(msg.chat_id, msg.id, nil,J..'ایدی : `'..Premium.sender_user_id..'`\n'..J..' نام کاربری : '..UseMark(UsrNm)..'\n'..J..' نام : *'..UseMark(Fname)..'*\n'..J..' بیوگرافی : \n'..UseMark(Bio)..'\n'..J..' گروه های مشترک با شما : '..common_chat_count, 1, false, nil, 'md')
								end
								tdbot.getUserFull(Premium.sender_user_id,GetFull)
								end
								tdbot.getUser(Premium.sender_user_id, GetUsername)
							end
						end
						tdbot.getMessage(msg.chat_id, tonumber(Msg_Reply), InfoByReply)
					end
					if Majhol_Self:match('^ایدی (.*)$') or Majhol_Self:match('^id (.*)$') then
						matches = {string.match(Majhol_Self, '^(%S+) (.*)$')}
						function ByUserName(Majhol,Premium)
							if Premium.id then
								if Premium.username and Premium.username ~= "" then
								username = "@" .. Premium.username
								else
								if Majhol and Majhol.username then
								username = Majhol.username
								username = username:gsub("@", "")
								username = "@" .. username
								else
								username = "ندارد"
								end
								end
								local function GetUsername(a, r)
										if r.first_name ~= '' then
										Fname = r.first_name
										else
										Fname = "ندارد"
										end
							function GetFull(extra, result)
								if result.about and result.about ~= "" then
								Bio = result.about
								else  
								Bio = 'ندارد'
								end
								if result.common_chat_count and result.common_chat_count ~= ""  then
								common_chat_count  = result.common_chat_count 
								else 
								common_chat_count  = 'ندارد'
								end
							tdbot.editMessageText(msg.chat_id, msg.id, nil,J..'ایدی : `'..Premium.id..'`\n'..J..' نام کاربری : '..UseMark(username)..'\n'..J..' نام : *'..(UseMark(Fname) or '')..'*\n'..J..' بیوگرافی : \n'..(UseMark(Bio) or '')..'\n'..J..' گروه های مشترک با شما : '..(common_chat_count or ''), 1, false, nil, 'md')
							end
							tdbot.getUserFull(Premium.id,GetFull)
							end
							tdbot.getUser((Premium.id or matches[2]), GetUsername)
						end
						end
						if matches[2]:match('^(%d+)$') then
							tdbot.getUser(tonumber(matches[2]), ByUserName)
						else
							tdbot.searchPublicChat(matches[2], ByUserName, {username = matches[2]})
						end
					end
					if Majhol_Self:match('^ایدی$') or Majhol_Self:match('^id$') then
						if ChatType == 'pv' then
							local function GetUsername(a, r)
							function GetFull(extra, result)
								if r.username ~= '' then
								UsrNm = '@'..r.username
								else
								UsrNm = 'ندارد'
								end
								if r.first_name ~= '' then
								Fname = r.first_name
								else
								Fname = "ندارد"
								end
								if result.about then
								Bio = result.about
								else  
								Bio = 'ندارد'
								end
								if result.common_chat_count  then
								common_chat_count  = result.common_chat_count 
								else 
								common_chat_count  = 'ندارد'
								end
							tdbot.editMessageText(msg.chat_id, msg.id, nil,J..'ایدی : `'..msg.chat_id..'`\n'..J..' نام کاربری : '..UseMark(UsrNm)..'\n'..J..' نام : *'..UseMark(Fname)..'*\n'..J..' بیوگرافی : \n'..UseMark(Bio)..'\n'..J..' گروه های مشترک با شما : '..common_chat_count, 1, false, nil, 'md')
							end
							tdbot.getUserFull(msg.chat_id,GetFull)
							end
							tdbot.getUser(msg.chat_id, GetUsername)
						elseif ChatType == 'channel' then
							local function group_info(arg, data)
								function GetFchat(a, r)
									tdbot.editMessageText(msg.chat_id, msg.id, nil, J..' اسم گروه : *'..UseMark(r.title)..'*\n'..J..' شناسه گروه : `'..msg.chat_id..'`\n'..J..' تعداد اعضا گروه : '..data.member_count, 1, false, nil, 'md')
								end
								tdbot.getChat(msg.chat_id,GetFchat)
							end
							tdbot.getChannelFull(msg.chat_id, group_info)
						else
							function GetFchat(a, r)
									tdbot.editMessageText(msg.chat_id, msg.id, nil, J..' اسم گروه : *'..UseMark(r.title)..'*\n'..J..' شناسه گروه : `'..msg.chat_id..'`', 1, false, nil, 'md')
								end
								tdbot.getChat(msg.chat_id,GetFchat)
						end
					end
					if Majhol_Self:match('^پاسخ {(.*)} (.*)$') then
					matches = {string.match(Majhol_Self, '^(پاسخ) {(.*)} (.*)$')}
					if redis:sismember(Profile.."SelfReply"..matches[2], matches[3]) then
					redis:srem(Profile.."SelfReply"..matches[2], matches[3])
					tdbot.editMessageText(msg.chat_id, msg.id, nil, STR.." پاسخ با موفقیت حذف شد", 1, false, nil, 'md')
					else
					redis:sadd(Profile.."SelfReply"..matches[2], matches[3])
					tdbot.editMessageText(msg.chat_id, msg.id, nil, STR.." پاسخ با موفقیت اضافه شد", 1, false, nil, 'md')
					end
					elseif Majhol_Self:match('^پاکسازی {(.*)}$') then
					matches = {string.match(Majhol_Self, '^(پاکسازی) {(.*)}$')}
					redis:del(Profile.."SelfReply"..matches[2])
					tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' پاسخ {'..matches[2]..'} حذف شد', 1, false, nil, 'md')
					elseif Majhol_Self:match('^پاسخها {(.*)}$') then
					matches = {string.match(Majhol_Self, '^(پاسخها) {(.*)}$')}
					ReplyHash = redis:smembers(Profile.."SelfReply"..matches[2])
					if #ReplyHash == 0 then
					tdbot.editMessageText(msg.chat_id, msg.id, nil,STR.." لیست پاسخ ها خالی است!", 1, false, nil, 'md')
					else
					text = STR..' لیست پاسخ های {'..matches[2]..'} :\n\n'
					for k,v in pairs(ReplyHash) do
					text = text..""..STR.." "..k.." :\n"..J.." "..v.."\n"
					end
					tdbot.editMessageText(msg.chat_id, msg.id, nil,text, 1, false, nil, 'md')
					end
					end
				if Majhol_Self:match('^اعتبار$') or Majhol_Self:match('^expire$') then
					Time = redis:ttl(Profile..'SelfExpire')
					year = math.floor(Time / 31536000)
					byear = Time % 31536000
					month = math.floor(byear / 2592000)
					bmonth = byear % 2592000
					day = math.floor(bmonth / 86400)
					bday = bmonth % 86400
					hours = math.floor( bday / 3600)
					bhours = bday % 3600
					min = math.floor(bhours / 60)
					sec = math.floor(bhours % 60)
					if tonumber(Time) > 1 and Time < 60 then
					  ExpireTime = sec..' ثانیه'
					elseif tonumber(Time) > 60 and Time < 3600 then
					  ExpireTime = min..' دقیقه و '..sec..' ثانیه'
					elseif tonumber(Time) > 3600 and tonumber(Time) < 86400 then
					  ExpireTime = hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه'
					elseif tonumber(Time) > 86400 and tonumber(Time) < 2592000 then
					  ExpireTime = day..' روز و '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه'
					elseif tonumber(Time) > 2592000 and tonumber(Time) < 31536000 then
					  ExpireTime = month..' ماه '..day..' روز و '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه'
					elseif tonumber(Time) > 31536000 then
					  ExpireTime = year..' سال '..month..' ماه '..day..' روز و '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه'
					end
					tdbot.editMessageText(msg.chat_id, msg.id, nil,STR..' سلف بات شما به مدت *'..ExpireTime..'* دیگر انقضا دارد', 1, false, nil, 'md')
				end
				if Majhol_Self:match('^تنظیمات$') or Majhol_Self:match('^settings$') then
					if redis:get(Profile..'SetMonshi') then
						Caption = redis:get(Profile..'SetMonshi') or ''
						TextMonshi = '*فعال*\nمتن منشی : `'..UseMark(Caption)..'`'
					else
						TextMonshi = '*غیرفعال*'
					end
					if redis:get(Profile..'MarkReadChat') == 'All' then
							MarkReadStatus = 'همه'
						elseif redis:get(Profile..'MarkReadChat') == 'Groups' then
							MarkReadStatus = 'گروه ها'
						elseif redis:get(Profile..'MarkReadChat') == 'Prvite' then
							MarkReadStatus = 'پیوی ها'
						else
							MarkReadStatus = 'خاموش'
					end
					if redis:get(Profile..'MarkReadChat'..msg.chat_id) then
						MarkreadHere = 'روشن'
					else
						MarkreadHere = 'خاموش'
					end
					if redis:get(Profile..'Answer:') then
						StatusAnswer = 'فعال'
					else
						StatusAnswer = 'غیرفعال'
					end
					if redis:get(Profile..'SmartBio:') then
						AutoBioText = tostring(redis:scard(Profile..'TextBio:') or 0)
						StatusSmartBio = '*فعال*\nتعداد بیو های ذخیره شده : *'..AutoBioText..'*'
					else
						StatusSmartBio = '*غیرفعال*'
					end
					Note = tostring(redis:scard(Profile..'Note:') or 0)
					Time = redis:ttl(Profile..'SelfExpire')
					year = math.floor(Time / 31536000)
					byear = Time % 31536000
					month = math.floor(byear / 2592000)
					bmonth = byear % 2592000
					day = math.floor(bmonth / 86400)
					bday = bmonth % 86400
					hours = math.floor( bday / 3600)
					bhours = bday % 3600
					min = math.floor(bhours / 60)
					sec = math.floor(bhours % 60)
					if tonumber(Time) > 1 and Time < 60 then
					  ExpireTime = sec..' ثانیه'
					elseif tonumber(Time) > 60 and Time < 3600 then
					  ExpireTime = min..' دقیقه و '..sec..' ثانیه'
					elseif tonumber(Time) > 3600 and tonumber(Time) < 86400 then
					  ExpireTime = hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه'
					elseif tonumber(Time) > 86400 and tonumber(Time) < 2592000 then
					  ExpireTime = day..' روز و '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه'
					elseif tonumber(Time) > 2592000 and tonumber(Time) < 31536000 then
					  ExpireTime = month..' ماه '..day..' روز و '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه'
					elseif tonumber(Time) > 31536000 then
					  ExpireTime = year..' سال '..month..' ماه '..day..' روز و '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه'
					end
					if redis:sismember(Profile..'SelfGpLock', msg.chat_id) then
						GpLock = 'فعال'
					else
						GpLock = 'غیر فعال'
					end
					PayMent = redis:get(Profile..'PayMent') or 'تنظیم نشده است'
					local function Info(arq,data)
						function BlockUser(a, d)
						FristName = data.first_name or 'تنظیم نشده است'
						LastName =   data.last_name or 'تنظیم نشده است'
						UserID = data.id
						UserName = data.username or 'تنظیم نشده است'
						PhoneNumber = data.phone_number
						BlockNum = d.total_count or 0
						text = J..' تنظیمات سلف شما : '..J..'\n\n'..STR..' منشی :'..TextMonshi..'\n'..STR..' وضعیت کلی خواندن پیام : *'..MarkReadStatus..'*\n'..STR..' وضعیت خواندن پیام این گفت و گو : *'..MarkreadHere..'*\n'..STR..' وضعیت قفل این گروه : *'..GpLock..'*\n'..STR..' ضعیت پاسخ خودکار : *'..StatusAnswer..'*\n'..STR..' وضعیت بیوگرافی خودکار : '..StatusSmartBio..'\n'..STR..' تعداد کاربران بلاک شده : *'..BlockNum..'*\n'..STR..' نام اکانت سلف : *'..Profile..'*\n'..STR..' شناسه شما : *'..UserID..'*\n'..STR..' نام : *'..FristName..'*\n'..STR..' نام خانوادگی : *'..LastName..'*\n'..STR..' نام کاربری : @'.. UseMark(UserName)..'\n'..STR..' شماره موبایل : *'..string.sub(PhoneNumber, 1, 8)..'0000'..'*\n'..STR..' اعتبار سلف بات : *'..ExpireTime..'*\n'..STR..' درگاه شما :'..PayMent
					tdbot.editMessageText(msg.chat_id, msg.id, nil, text, 1, false, nil, 'md')
					end
						tdbot.getBlockedUsers(0, 100,BlockUser)
					end
					tdbot.getMe(Info)
				end
				if (Majhol_Self:match('^آمار$') or Majhol_Self:match('^امار$') or Majhol_Self:match('^status$') or Majhol_Self:match('^stats$')) then
					SGroup = tostring(redis:scard(Profile.."SuperGroup:") or 0)
					Group = tostring(redis:scard(Profile.."Group:") or 0)
					Pv = tostring(redis:scard(Profile.."Prvite:") or 0)
					AllPmChat = tostring(redis:get(Profile.."AllMsgChats") or 0)
					AllPmYou = tostring(redis:get(Profile.."AllMsgYou") or 0)
					AutoBioText = tostring(redis:scard(Profile..'TextBio:') or 0)
					ChatMarkread = tostring(redis:scard(Profile..'MarkReadChatHere') or 0)
					text = J.." آمار سلف شما : "..J.."\n\n"..J.." تعداد گروه ها : "..Group.."\n"..J.." تعداد سوپرگروه ها : "..SGroup.."\n"..J.." تعداد پیوی ها : "..Pv.."\n"..J.." همه پیام ها : "..AllPmChat.."\n"..J.." همه پیام های شما: "..AllPmYou.."\n"..J.." تعداد بیوگرافی تنظیم شده : "..AutoBioText.."\n"..J.." تعداد چت های تیک خورده : "..ChatMarkread
					tdbot.editMessageText(msg.chat_id, msg.id, nil, text, 1, false, nil, 'md')
				end
				if Majhol_Self:match('^منشن (%d+)$') or Majhol_Self:match('^mention (%d+)$') then
					matches = {string.match(Majhol_Self, '^(.*) (%d+)$')}
					function CallBack(arg, data)
						if data.id then
							tdbot.deleteMessages(msg.chat_id, msg.id, true)
							sendMetion(msg.chat_id, data.id, (Msg_Reply or 0), data.first_name)
						end
					end
					tdbot.getUser(tonumber(matches[2]), CallBack)
				end
				if Majhol_Self:match('^منشن (%d+) (.*)$') or Majhol_Self:match('^mention (%d+) (.*)$') then
					matches = {string.match(Majhol_Self, '^(.*) (%d+) (.*)$')}
					function CallBack(arg, data)
						if data.id then
							tdbot.deleteMessages(msg.chat_id, msg.id, true)
							sendMetion(msg.chat_id, data.id, (Msg_Reply or 0), matches[3])
						end
					end
					tdbot.getUser(tonumber(matches[2]), CallBack)
				end
				if Majhol_Self:match('^منشن (.*) (.*)$') or Majhol_Self:match('^mention (.*) (.*)$') then
					matchesFA = {string.match(Majhol_Self, '^(منشن) (%S+) (.*)$')}
					matchesEN = {string.match(Majhol_Self, '^(mention) (%S+) (.*)$')}
					text = matchesEN[3] or matchesFA[3]
					id = matchesEN[2] or matchesFA[2]
					function CallBack(arg, data)
						if data.id and type(data.id) == 'number' then
							tdbot.deleteMessages(msg.chat_id, msg.id, true)
							sendMetion(msg.chat_id, data.id, (Msg_Reply or 0), text)
						end
					end
					tdbot.searchPublicChat(id, CallBack)
				end
				if (Majhol_Self:match('^منشن (.*)$') or Majhol_Self:match('^mention (.*)$')) and not Msg_Reply then
					matches = {string.match(Majhol_Self, '^(.*) (.*)$')}
					function CallBack(arg, data)
						if data.id and type(data.id) == 'number' then
							tdbot.deleteMessages(msg.chat_id, msg.id, true)
							sendMetion(msg.chat_id, data.id, (Msg_Reply or 0), data.title)
						end
					end
					tdbot.searchPublicChat(matches[2], CallBack)
				end
				if (Majhol_Self:match('^منشن (.*)$') or Majhol_Self:match('^mention (.*)$')) and Msg_Reply then
					matches = {string.match(Majhol_Self, '^(%S+) (.*)$')}
					function CallBack(arg, data)
						if data.sender_user_id then
							tdbot.deleteMessages(msg.chat_id, msg.id, true)
							sendMetion(msg.chat_id, data.sender_user_id, (Msg_Reply or 0), matches[2])
						end
					end
					tdbot.getMessage(msg.chat_id, Msg_Reply, CallBack)
				end
				if (Majhol_Self:match('^سیو$') or Majhol_Self:match('^ذخیره$') or Majhol_Self:match('^save$')) and Msg_Reply then
					function CallBack(arg, data)
						if data.content._ == 'messageContact' then
							contact = data.content.contact
							tdbot.importContacts(contact.phone_number, contact.first_name, '', contact.user_id)
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' مخاطب با نام *'..contact.first_name..'* ذخیره شد', 1, false, nil, 'md')
						else
								function callback2(arg, data)
								tdbot.openChat(data.id)
								tdbot.forwardMessages(data.id, msg.chat_id, Msg_Reply) 
							end
								function callback(arg, data)
									if data.username ~= '' then tdbot.searchPublicChat(data.username, callback2)
									else
										callback2(nil, {id=MasterId})
									end
								end
							tdbot.getUser(MasterId, callback)
						end
					end
					tdbot.getMessage(msg.chat_id, Msg_Reply, CallBack)
				end
				if msg.content.text:match('^دانلود (.*)$') or msg.content.text:match('^dl (.*)$') then
					matches = {string.match(msg.content.text, '^(.*) (.*)$')}
					if matches[2]:match('https') or matches[2]:match('http') then
						math.randomseed(os.time())
						i = math.random(100,999)
						path = './Data/'..i
						f = false
						if matches[2]:match('.jpg') then
							f = '.jpg'
							t = 5
						elseif matches[2]:match('.png') then
							f = '.png'
							t = 5
						elseif matches[2]:match('.mp3') then
							f = '.mp3'
							t = 10
						elseif matches[2]:match('.mp4') then
							f = '.mp4'
							t = 20
						elseif matches[2]:match('.mkv') then
							f = '.mkv'
							t = 20
						elseif matches[2]:match('.apk') then
							f = '.apk'
							t = 20
						elseif matches[2]:match('.zip') then
							f = '.zip'
							t = 30
						elseif matches[2]:match('.rar') then
							f = '.rar'
							t = 20
						elseif matches[2]:match('.bin') then
							f = '.bin'
							t = 20
						elseif matches[2]:match('.sh') then
							f = '.sh'
							t = 5
						elseif matches[2]:match('.txt') then
							f = '.txt'
							t = 5
						end
						if f then
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' در حال دانلود', 1, false, nil, 'md')
							function alarm(a, b)
								if a.i == 1 then
									t2 = a.t2
									if t == t2 then
										tdbot.sendDocument(msg.chat_id, path..'-download'..f, ' ', nil, 0, 0, 1, nil)
										tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' در حال آپلود کردن ...\nزمان احتمالی برای آپلود '..t2..' ثانیه', 1, false, nil, 'md')
										tdbot.setAlarm(1, alarm, {i=1,t2=t2-1})
									elseif t2 <= 0 then
										tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' حذف فایل اضافه از سرور ...', 1, false, nil, 'md')
										tdbot.setAlarm(t, alarm, {i=2})
									elseif t2 >= 0 then
										tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' در حال آپلود کردن ...\nزمان احتمالی برای آپلود '..t2..' ثانیه', 1, false, nil, 'md')
										tdbot.setAlarm(1, alarm, {i=1,t2=t2-1})
									end
								elseif a.i == 2 then
									tdbot.deleteMessages(msg.chat_id, msg.id, true)
									runRequest('rm '..path..'-download'..f)
								else
									io.popen('wget -O '..path..'-download'..f..' "'..matches[2]..'"'):read("*a")
									tdbot.setAlarm(1, alarm, {i=1,t2=t+1})
								end
							end
							tdbot.setAlarm(1, alarm, {i=0})
						end
					end
				end
				if msg.content.text:match('^تنظیم بیوگرافی (.*)$') or msg.content.text:match('^setbio (.*)$') then
					AboutBot = msg.content.text:match('^تنظیم بیوگرافی (.*)$') or msg.content.text:match('^setbio (.*)$')
					tdbot.changeAbout(AboutBot)
					tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' بیوگرافی شما تغییر کرد به : '..UseMark(AboutBot), 1, false, nil, 'md')
				end
				if msg.content.text:match('^تنظیم یوزرنیم (.*)$') or msg.content.text:match('^setusername (.*)$') then
					User = msg.content.text:match('^تنظیم یوزرنیم (.*)$') or msg.content.text:match('^setusername (.*)$')
					User = User:gsub('@','')
					tdbot.changeUsername(User)
					tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' یوزرنیم شما تغییر کرد به : @'..UseMark(User), 1, false, nil, 'md')
				end
				if msg.content.text:match('^تنظیم اسم (.*)$') or msg.content.text:match('^setname (.*)$') then
					Name = msg.content.text:match('^تنظیم اسم (.*)$') or msg.content.text:match('^setname (.*)$')
					tdbot.changeName(Name,'')
					tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' اسم شما تغییر کرد به : '..UseMark(Name), 1, false, nil, 'md')
				end
				if msg.content.text:match('^تنظیم درگاه (.*)$') or msg.content.text:match('^setpay (.*)$') then
					PayMent = msg.content.text:match('^تنظیم درگاه (.*)$') or msg.content.text:match('^setpay (.*)$')
					if (PayMent:match('http://idpay.ir/(.*)') or PayMent:match('http://payping.ir/(.*)') or PayMent:match('http://zarinp.al/(.*)')) then
						redis:set(Profile.."PayMent", PayMent)
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' درگاه شما تنظیم شد به : \n'..PayMent, 1, false, nil, 'md')
					else
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' لینک وارد شده اشتباه میباشد', 1, false, nil, 'md')
					end
				end
				if Majhol_Self:match('^پرداخت (%d+)$') or Majhol_Self:match('^payment (%d+)$') then
					Number = tonumber(Majhol_Self:match('(%d+)$'))
					if Number < 1000 then
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' مبلغ وارد شده باید بیشتر از هزار تومن باشد.', 1, false, nil, 'md')
					else
						Pay = redis:get(Profile.."PayMent")
						if Pay then
							texth = J.." پرداخت مبلغ "..Number.." تومان "..J
							function callback(arg, result)
							  if result.results and result.results[0] then
								tdbot.sendInlineQueryResultMessage(msg.chat_id, msg.id, 0, 1, result.inline_query_id, result.results[0].id)
							  else
								tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' لطفا ابتدا ربات @Bold را استارت کنید', 1, false, nil, 'md')
							  end
							end
							if Pay:match('idpay.ir/') then 
								tdbot.deleteMessages(msg.chat_id, msg.id, true)
								tdbot.getInlineQueryResults(107705060, msg.chat_id, 0, 0, "[ "..texth.."]("..Pay.."/"..Number.."0)", 0, callback)
							else
								tdbot.deleteMessages(msg.chat_id, msg.id, true)
								tdbot.getInlineQueryResults(107705060, msg.chat_id, 0, 0, "[ "..texth.."]("..Pay.."/"..Number..")", 0, callback)
							end
						else
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..' درگاهی تنظیم نشده است', 1, false, nil, 'md')
						end
					end
				end
				if (Majhol_Self:match('^تبدیل$') or Majhol_Self:match('^convert$')) and Msg_Reply then
					function CallBack(arg, data)
						if data.content._ == 'messagePhoto' then
							tdbot.sendSticker(msg.chat_id, msg.id, data.content.photo.sizes[0].photo.path)
						elseif data.content._ == 'messageSticker' then
							tdbot.downloadFile(data.content.sticker.sticker.id, 32)
							function alarm(a, d)
								function getSticker(ar, da)
									tdbot.sendPhoto(msg.chat_id, msg.id, da.content.sticker.sticker.path, nil, 512, 512, ' ')
								end
								tdbot.getMessage(msg.chat_id, data.id, getSticker)
							end
							tdbot.setAlarm(1, alarm)
						end
					end
					tdbot.getMessage(msg.chat_id, Msg_Reply, CallBack)
				end
				if Majhol_Self:match('^بدخواه (.*)$') or Majhol_Self:match('^enemy (.*)$') then
					matches = {string.match(Majhol_Self, '^(.*) (.*)$')}
					list = redis:smembers(Profile..'EnemyWord')
					if matches[2] == 'روشن' or matches[2] == 'on' then
						if #list == 0 then
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..'لسیت فحش خالی میباشد لطفا چیزی اضافه کنید', 1, false, nil, 'md')
						else
							tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..'حالت بدخواه فعال شد', 1, false, nil, 'md')
							redis:set(Profile..'Enemy', true)
						end
					elseif matches[2] == 'خاموش' or matches[2] == 'off' then
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..'حالت بدخواه غیرفعال شد', 1, false, nil, 'md')
						redis:del(Profile..'Enemy')
					end
				end
				if Majhol_Self:match('^فحش (.*)$') or Majhol_Self:match('^fosh (.*)$') then
					matches = {string.match(msg.content.text, '^(.*) (.*)$')}
					if redis:sismember(Profile..'EnemyWord', matches[2]) then
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..'کلمه '..UseMark(matches[2])..' از لیست فحش حذف شد', 1, false, nil, 'md')
						redis:srem(Profile..'EnemyWord', matches[2])
					else
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..'کلمه '..UseMark(matches[2])..' به لیست فحش اضافه شد', 1, false, nil, 'md')
						redis:sadd(Profile..'EnemyWord', matches[2])
					end
				end
				if Majhol_Self:match('^بدخواه$') or Majhol_Self:match('^setenemy$') and Msg_Reply then
					function BlockByReply(Majhol,Premium)
						if checkSudo(Premium.sender_user_id, msg) then return false end
						redis:sadd(Profile..'EnemyUser', Premium.sender_user_id)
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..'کاربر `'..Premium.sender_user_id..'` به لیست بدخواه اضافه شد', 1, false, nil, 'md')
					end
					tdbot.getMessage(msg.chat_id, tonumber(Msg_Reply), BlockByReply)
				end
				if Majhol_Self:match('^بدخواه (%d+)$') or Majhol_Self:match('^setenemy (%d+)$') then
					matches = {string.match(Majhol_Self, '^(.*) (%d+)$')}
					if checkSudo(matches[2], msg) then return false end
					redis:sadd(Profile..'EnemyUser', matches[2])
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..'کاربر `'..matches[2]..'` به لیست بدخواه اضافه شد', 1, false, nil, 'md')
				end
				if Majhol_Self:match('^بدخواه (.*)$') or Majhol_Self:match('^setenemy (.*)$') then
					matches = {string.match(Majhol_Self, '^(.*) (.*)$')}
					function BlockByUserName(Majhol,Premium)
						if Premium.id then
						if checkSudo(Premium.id, msg) then return false end
							redis:sadd(Profile..'EnemyUser', Premium.id)
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..'کاربر `'..Premium.id..'` به لیست بدخواه اضافه شد', 1, false, nil, 'md')
						end
					end
					tdbot.searchPublicChat(matches[2], BlockByUserName)
				end
				if Majhol_Self:match('^حذف بدخواه$') or Majhol_Self:match('^delenemy$') and Msg_Reply then
					function BlockByReply(Majhol,Premium)
						if checkSudo(Premium.sender_user_id, msg) then return false end
						redis:srem(Profile..'EnemyUser', Premium.sender_user_id)
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..'کاربر `'..Premium.sender_user_id..'` از لیست بدخواه حذف شد', 1, false, nil, 'md')
					end
					tdbot.getMessage(msg.chat_id, tonumber(Msg_Reply), BlockByReply)
				end
				if Majhol_Self:match('^حذف بدخواه (%d+)$') or Majhol_Self:match('^delenemy (%d+)$') then
					matches = {string.match(Majhol_Self, '^(.*) (%d+)$')}
					if checkSudo(matches[2], msg) then return false end
					redis:srem(Profile..'EnemyUser', matches[2])
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..'کاربر `'..matches[2]..'` از لیست بدخواه حذف شد', 1, false, nil, 'md')
				end
				if Majhol_Self:match('^حذف بدخواه (.*)$') or Majhol_Self:match('^delenemy (.*)$') then
					matchesFA = {string.match(Majhol_Self, '^حذف بدخواه (.*)$')}
					matchesEN = {string.match(Majhol_Self, '^delenemy (.*)$')}
					username = matchesEN[1] or matchesFA[1]
					function BlockByUserName(Majhol,Premium)
						if Premium.id then
						if checkSudo(Premium.id, msg) then return false end
							redis:srem(Profile..'EnemyUser', Premium.id)
						tdbot.editMessageText(msg.chat_id, msg.id, nil, STR..'کاربر `'..Premium.id..'` از لیست بدخواه حذف شد', 1, false, nil, 'md')
						end
					end
					tdbot.searchPublicChat(username, BlockByUserName)
				end
				if Majhol_Self:match('^لیست (.*)$') or Majhol_Self:match('^list (.*)$') then
					matches = {string.match(Majhol_Self, '^(.*) (.*)$')}
					if matches[2] == 'بدخواه' or matches[2] == 'enemy' then
						list = redis:smembers(Profile..'EnemyUser')
						text = 'لیست بدخواه ها : \n\n'
						if #list ~= 0 then
							for k,v in pairs(list) do
							text = text..'`'..v..'`\n'
							end
						else
							text = 'لیست خالی میباشد'
						end
						tdbot.editMessageText(msg.chat_id, msg.id, nil, text, 1, false, nil, 'md')
					elseif matches[2] == 'فحش' or matches[2] == 'fosh' then
						list = redis:smembers(Profile..'EnemyWord')
						text = 'لیست فحش ها : \n\n'
						if #list ~= 0 then
							for k,v in pairs(list) do
							text = text..'`'..v..'`\n'
							end
						else
							text = 'لیست خالی میباشد'
						end
						tdbot.editMessageText(msg.chat_id, msg.id, nil, text, 1, false, nil, 'md')
					end
				end
				if (Majhol_Self:match('^font (.*)$') or Majhol_Self:match('^فونت (.*)$')) then
				matches = {string.match(msg.content.text, '^(%S+) (.*)$')}
				WORD = matches[2]:gsub(' ','')
				if WORD:match("[\65-\90]") or WORD:match("[\97-\122]") then
				if #WORD < 2 then
					tdbot.editMessageText(msg.chat_id, msg.id, nil, 'بعد از این دستور، با قید یک فاصله کلمه یا جمله ی مورد نظر را جهت زیبا نویسی وارد کنید', 1, false, nil, 'md')
					end
					if string.len(WORD) > 20 then
					tdbot.editMessageText(msg.chat_id, msg.id, nil, 'حداکثر حروف مجاز 20 کاراکتر  و عدد است', 1, false, nil, 'md')
					end
					 font_base = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,9,8,7,6,5,4,3,2,1,.,_"
					 font_hash = "z,y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,Z,Y,X,W,V,U,T,S,R,Q,P,O,N,M,L,K,J,I,H,G,F,E,D,C,B,A,0,1,2,3,4,5,6,7,8,9,.,_"
					fonts_en = {
				  "ⓐ,ⓑ,ⓒ,ⓓ,ⓔ,ⓕ,ⓖ,ⓗ,ⓘ,ⓙ,ⓚ,ⓛ,ⓜ,ⓝ,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,ⓣ,ⓤ,ⓥ,ⓦ,ⓧ,ⓨ,ⓩ,ⓐ,ⓑ,ⓒ,ⓓ,ⓔ,ⓕ,ⓖ,ⓗ,ⓘ,ⓙ,ⓚ,ⓛ,ⓜ,ⓝ,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,ⓣ,ⓤ,ⓥ,ⓦ,ⓧ,ⓨ,ⓩ,⓪,➈,➇,➆,➅,➄,➃,➂,➁,➀,●,_",
				  "⒜,⒝,⒞,⒟,⒠,⒡,⒢,⒣,⒤,⒥,⒦,⒧,⒨,⒩,⒪,⒫,⒬,⒭,⒮,⒯,⒰,⒱,⒲,⒳,⒴,⒵,⒜,⒝,⒞,⒟,⒠,⒡,⒢,⒣,⒤,⒥,⒦,⒧,⒨,⒩,⒪,⒫,⒬,⒭,⒮,⒯,⒰,⒱,⒲,⒳,⒴,⒵,⓪,⑼,⑻,⑺,⑹,⑸,⑷,⑶,⑵,⑴,.,_",
				  "α,в,c,∂,є,ƒ,g,н,ι,נ,к,ℓ,м,η,σ,ρ,q,я,ѕ,т,υ,ν,ω,χ,у,z,α,в,c,∂,є,ƒ,g,н,ι,נ,к,ℓ,м,η,σ,ρ,q,я,ѕ,т,υ,ν,ω,χ,у,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "α,в,c,d,e,ғ,ɢ,н,ι,j,ĸ,l,м,ɴ,o,p,q,r,ѕ,т,υ,v,w,х,y,z,α,в,c,d,e,ғ,ɢ,н,ι,j,ĸ,l,м,ɴ,o,p,q,r,ѕ,т,υ,v,w,х,y,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "α,в,¢,đ,e,f,g,ħ,ı,נ,κ,ł,м,и,ø,ρ,q,я,š,т,υ,ν,ω,χ,ч,z,α,в,¢,đ,e,f,g,ħ,ı,נ,κ,ł,м,и,ø,ρ,q,я,š,т,υ,ν,ω,χ,ч,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ą,ҍ,ç,ժ,ҽ,ƒ,ց,հ,ì,ʝ,ҟ,Ӏ,ʍ,ղ,օ,ք,զ,ɾ,ʂ,է,մ,ѵ,ա,×,վ,Հ,ą,ҍ,ç,ժ,ҽ,ƒ,ց,հ,ì,ʝ,ҟ,Ӏ,ʍ,ղ,օ,ք,զ,ɾ,ʂ,է,մ,ѵ,ա,×,վ,Հ,⊘,९,𝟠,7,Ϭ,Ƽ,५,Ӡ,ϩ,𝟙,.,_",		"ค,ც,८,ძ,૯,Բ,૭,Һ,ɿ,ʆ,қ,Ն,ɱ,Ո,૦,ƿ,ҩ,Ր,ς,੮,υ,౮,ω,૪,ע,ઽ,ค,ც,८,ძ,૯,Բ,૭,Һ,ɿ,ʆ,қ,Ն,ɱ,Ո,૦,ƿ,ҩ,Ր,ς,੮,υ,౮,ω,૪,ע,ઽ,0,9,8,7,6,5,4,3,2,1,.,_",
				  "α,ß,ς,d,ε,ƒ,g,h,ï,յ,κ,ﾚ,m,η,⊕,p,Ω,r,š,†,u,∀,ω,x,ψ,z,α,ß,ς,d,ε,ƒ,g,h,ï,յ,κ,ﾚ,m,η,⊕,p,Ω,r,š,†,u,∀,ω,x,ψ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ค,๒,ς,๔,є,Ŧ,ɠ,ђ,เ,ן,к,l,๓,ภ,๏,թ,ợ,г,ร,t,ย,v,ฬ,x,ץ,z,ค,๒,ς,๔,є,Ŧ,ɠ,ђ,เ,ן,к,l,๓,ภ,๏,թ,ợ,г,ร,t,ย,v,ฬ,x,ץ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ﾑ,乃,ζ,Ð,乇,ｷ,Ǥ,ん,ﾉ,ﾌ,ズ,ﾚ,ᄊ,刀,Ծ,ｱ,Q,尺,ㄎ,ｲ,Ц,Џ,Щ,ﾒ,ﾘ,乙,ﾑ,乃,ζ,Ð,乇,ｷ,Ǥ,ん,ﾉ,ﾌ,ズ,ﾚ,ᄊ,刀,Ծ,ｱ,q,尺,ㄎ,ｲ,Ц,Џ,Щ,ﾒ,ﾘ,乙,ᅙ,9,8,ᆨ,6,5,4,3,ᆯ,1,.,_",
				  "α,β,c,δ,ε,Ŧ,ĝ,h,ι,j,κ,l,ʍ,π,ø,ρ,φ,Ʀ,$,†,u,υ,ω,χ,ψ,z,α,β,c,δ,ε,Ŧ,ĝ,h,ι,j,κ,l,ʍ,π,ø,ρ,φ,Ʀ,$,†,u,υ,ω,χ,ψ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ձ,ъ,ƈ,ժ,ε,բ,ց,հ,ﻨ,յ,ĸ,l,ო,ռ,օ,թ,զ,г,ร,է,ս,ν,ա,×,ყ,২,ձ,ъ,ƈ,ժ,ε,բ,ց,հ,ﻨ,յ,ĸ,l,ო,ռ,օ,թ,զ,г,ร,է,ս,ν,ա,×,ყ,২,0,9,8,7,6,5,4,3,2,1,.,_",
				  "Λ,ɓ,¢,Ɗ,£,ƒ,ɢ,ɦ,ĩ,ʝ,Қ,Ł,ɱ,ה,ø,Ṗ,Ҩ,Ŕ,Ş,Ŧ,Ū,Ɣ,ω,Ж,¥,Ẑ,Λ,ɓ,¢,Ɗ,£,ƒ,ɢ,ɦ,ĩ,ʝ,Қ,Ł,ɱ,ה,ø,Ṗ,Ҩ,Ŕ,Ş,Ŧ,Ū,Ɣ,ω,Ж,¥,Ẑ,0,9,8,7,6,5,4,3,2,1,.,_",
				  "Λ,Б,Ͼ,Ð,Ξ,Ŧ,G,H,ł,J,К,Ł,M,Л,Ф,P,Ǫ,Я,S,T,U,V,Ш,Ж,Џ,Z,Λ,Б,Ͼ,Ð,Ξ,Ŧ,g,h,ł,j,К,Ł,m,Л,Ф,p,Ǫ,Я,s,t,u,v,Ш,Ж,Џ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ɐ,q,ɔ,p,ǝ,ɟ,ɓ,ɥ,ı,ſ,ʞ,ๅ,ɯ,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,ɐ,q,ɔ,p,ǝ,ɟ,ɓ,ɥ,ı,ſ,ʞ,ๅ,ɯ,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ɒ,d,ɔ,b,ɘ,ʇ,ϱ,н,i,į,ʞ,l,м,и,o,q,p,я,ƨ,т,υ,v,w,x,γ,z,ɒ,d,ɔ,b,ɘ,ʇ,ϱ,н,i,į,ʞ,l,м,и,o,q,p,я,ƨ,т,υ,v,w,x,γ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "A̴,̴B̴,̴C̴,̴D̴,̴E̴,̴F̴,̴G̴,̴H̴,̴I̴,̴J̴,̴K̴,̴L̴,̴M̴,̴N̴,̴O̴,̴P̴,̴Q̴,̴R̴,̴S̴,̴T̴,̴U̴,̴V̴,̴W̴,̴X̴,̴Y̴,̴Z̴,̴a̴,̴b̴,̴c̴,̴d̴,̴e̴,̴f̴,̴g̴,̴h̴,̴i̴,̴j̴,̴k̴,̴l̴,̴m̴,̴n̴,̴o̴,̴p̴,̴q̴,̴r̴,̴s̴,̴t̴,̴u̴,̴v̴,̴w̴,̴x̴,̴y̴,̴z̴,̴0̴,̴9̴,̴8̴,̴7̴,̴6̴,̴5̴,̴4̴,̴3̴,̴2̴,̴1̴,̴.̴,̴_̴",
				  "ⓐ,ⓑ,ⓒ,ⓓ,ⓔ,ⓕ,ⓖ,ⓗ,ⓘ,ⓙ,ⓚ,ⓛ,ⓜ,ⓝ,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,ⓣ,ⓤ,ⓥ,ⓦ,ⓧ,ⓨ,ⓩ,ⓐ,ⓑ,ⓒ,ⓓ,ⓔ,ⓕ,ⓖ,ⓗ,ⓘ,ⓙ,ⓚ,ⓛ,ⓜ,ⓝ,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,ⓣ,ⓤ,ⓥ,ⓦ,ⓧ,ⓨ,ⓩ,⓪,➈,➇,➆,➅,➄,➃,➂,➁,➀,●,_",
				  "⒜,⒝,⒞,⒟,⒠,⒡,⒢,⒣,⒤,⒥,⒦,⒧,⒨,⒩,⒪,⒫,⒬,⒭,⒮,⒯,⒰,⒱,⒲,⒳,⒴,⒵,⒜,⒝,⒞,⒟,⒠,⒡,⒢,⒣,⒤,⒥,⒦,⒧,⒨,⒩,⒪,⒫,⒬,⒭,⒮,⒯,⒰,⒱,⒲,⒳,⒴,⒵,⓪,⑼,⑻,⑺,⑹,⑸,⑷,⑶,⑵,⑴,.,_",
				  "α,в,c,∂,є,ƒ,g,н,ι,נ,к,ℓ,м,η,σ,ρ,q,я,ѕ,т,υ,ν,ω,χ,у,z,α,в,c,∂,є,ƒ,g,н,ι,נ,к,ℓ,м,η,σ,ρ,q,я,ѕ,т,υ,ν,ω,χ,у,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "α,в,c,ɗ,є,f,g,н,ι,נ,к,Ɩ,м,η,σ,ρ,q,я,ѕ,т,υ,ν,ω,x,у,z,α,в,c,ɗ,є,f,g,н,ι,נ,к,Ɩ,м,η,σ,ρ,q,я,ѕ,т,υ,ν,ω,x,у,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "α,в,c,d,e,ғ,ɢ,н,ι,j,ĸ,l,м,ɴ,o,p,q,r,ѕ,т,υ,v,w,х,y,z,α,в,c,d,e,ғ,ɢ,н,ι,j,ĸ,l,м,ɴ,o,p,q,r,ѕ,т,υ,v,w,х,y,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "α,Ⴆ,ƈ,ԃ,ҽ,ϝ,ɠ,ԋ,ι,ʝ,ƙ,ʅ,ɱ,ɳ,σ,ρ,ϙ,ɾ,ʂ,ƚ,υ,ʋ,ɯ,x,ყ,ȥ,α,Ⴆ,ƈ,ԃ,ҽ,ϝ,ɠ,ԋ,ι,ʝ,ƙ,ʅ,ɱ,ɳ,σ,ρ,ϙ,ɾ,ʂ,ƚ,υ,ʋ,ɯ,x,ყ,ȥ,0,9,8,7,6,5,4,3,2,1,.,_",
				  "α,в,¢,đ,e,f,g,ħ,ı,נ,κ,ł,м,и,ø,ρ,q,я,š,т,υ,ν,ω,χ,ч,z,α,в,¢,đ,e,f,g,ħ,ı,נ,κ,ł,м,и,ø,ρ,q,я,š,т,υ,ν,ω,χ,ч,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ą,ɓ,ƈ,đ,ε,∱,ɠ,ɧ,ï,ʆ,ҡ,ℓ,ɱ,ŋ,σ,þ,ҩ,ŗ,ş,ŧ,ų,√,щ,х,γ,ẕ,ą,ɓ,ƈ,đ,ε,∱,ɠ,ɧ,ï,ʆ,ҡ,ℓ,ɱ,ŋ,σ,þ,ҩ,ŗ,ş,ŧ,ų,√,щ,х,γ,ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ą,ҍ,ç,ժ,ҽ,ƒ,ց,հ,ì,ʝ,ҟ,Ӏ,ʍ,ղ,օ,ք,զ,ɾ,ʂ,է,մ,ѵ,ա,×,վ,Հ,ą,ҍ,ç,ժ,ҽ,ƒ,ց,հ,ì,ʝ,ҟ,Ӏ,ʍ,ղ,օ,ք,զ,ɾ,ʂ,է,մ,ѵ,ա,×,վ,Հ,⊘,९,𝟠,7,Ϭ,Ƽ,५,Ӡ,ϩ,𝟙,.,_",
				  "მ,ჩ,ƈ,ძ,ε,բ,ց,հ,ἶ,ʝ,ƙ,l,ო,ղ,օ,ր,գ,ɾ,ʂ,է,մ,ν,ω,ჯ,ყ,z,მ,ჩ,ƈ,ძ,ε,բ,ց,հ,ἶ,ʝ,ƙ,l,ო,ղ,օ,ր,գ,ɾ,ʂ,է,մ,ν,ω,ჯ,ყ,z,0,Գ,Ց,Դ,6,5,Վ,Յ,Զ,1,.,_",
				  "ค,ც,८,ძ,૯,Բ,૭,Һ,ɿ,ʆ,қ,Ն,ɱ,Ո,૦,ƿ,ҩ,Ր,ς,੮,υ,౮,ω,૪,ע,ઽ,ค,ც,८,ძ,૯,Բ,૭,Һ,ɿ,ʆ,қ,Ն,ɱ,Ո,૦,ƿ,ҩ,Ր,ς,੮,υ,౮,ω,૪,ע,ઽ,0,9,8,7,6,5,4,3,2,1,.,_",
				  "α,ß,ς,d,ε,ƒ,g,h,ï,յ,κ,ﾚ,m,η,⊕,p,Ω,r,š,†,u,∀,ω,x,ψ,z,α,ß,ς,d,ε,ƒ,g,h,ï,յ,κ,ﾚ,m,η,⊕,p,Ω,r,š,†,u,∀,ω,x,ψ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ª,b,¢,Þ,È,F,૬,ɧ,Î,j,Κ,Ļ,м,η,◊,Ƿ,ƍ,r,S,⊥,µ,√,w,×,ý,z,ª,b,¢,Þ,È,F,૬,ɧ,Î,j,Κ,Ļ,м,η,◊,Ƿ,ƍ,r,S,⊥,µ,√,w,×,ý,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "Δ,Ɓ,C,D,Σ,F,G,H,I,J,Ƙ,L,Μ,∏,Θ,Ƥ,Ⴓ,Γ,Ѕ,Ƭ,Ʊ,Ʋ,Ш,Ж,Ψ,Z,λ,ϐ,ς,d,ε,ғ,ɢ,н,ι,ϳ,κ,l,ϻ,π,σ,ρ,φ,г,s,τ,υ,v,ш,ϰ,ψ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ค,๒,ς,๔,є,Ŧ,ɠ,ђ,เ,ן,к,l,๓,ภ,๏,թ,ợ,г,ร,t,ย,v,ฬ,x,ץ,z,ค,๒,ς,๔,є,Ŧ,ɠ,ђ,เ,ן,к,l,๓,ภ,๏,թ,ợ,г,ร,t,ย,v,ฬ,x,ץ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "Λ,ß,Ƈ,D,Ɛ,F,Ɠ,Ĥ,Ī,Ĵ,Ҡ,Ŀ,M,И,♡,Ṗ,Ҩ,Ŕ,S,Ƭ,Ʊ,Ѵ,Ѡ,Ӿ,Y,Z,Λ,ß,Ƈ,D,Ɛ,F,Ɠ,Ĥ,Ī,Ĵ,Ҡ,Ŀ,M,И,♡,Ṗ,Ҩ,Ŕ,S,Ƭ,Ʊ,Ѵ,Ѡ,Ӿ,Y,Z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ﾑ,乃,ζ,Ð,乇,ｷ,Ǥ,ん,ﾉ,ﾌ,ズ,ﾚ,ᄊ,刀,Ծ,ｱ,Q,尺,ㄎ,ｲ,Ц,Џ,Щ,ﾒ,ﾘ,乙,ﾑ,乃,ζ,Ð,乇,ｷ,Ǥ,ん,ﾉ,ﾌ,ズ,ﾚ,ᄊ,刀,Ծ,ｱ,q,尺,ㄎ,ｲ,Ц,Џ,Щ,ﾒ,ﾘ,乙,ᅙ,9,8,ᆨ,6,5,4,3,ᆯ,1,.,_",
				  "α,β,c,δ,ε,Ŧ,ĝ,h,ι,j,κ,l,ʍ,π,ø,ρ,φ,Ʀ,$,†,u,υ,ω,χ,ψ,z,α,β,c,δ,ε,Ŧ,ĝ,h,ι,j,κ,l,ʍ,π,ø,ρ,φ,Ʀ,$,†,u,υ,ω,χ,ψ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ค,๖,¢,໓,ē,f,ງ,h,i,ว,k,l,๓,ຖ,໐,p,๑,r,Ş,t,น,ง,ຟ,x,ฯ,ຊ,ค,๖,¢,໓,ē,f,ງ,h,i,ว,k,l,๓,ຖ,໐,p,๑,r,Ş,t,น,ง,ຟ,x,ฯ,ຊ,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ձ,ъ,ƈ,ժ,ε,բ,ց,հ,ﻨ,յ,ĸ,l,ო,ռ,օ,թ,զ,г,ร,է,ս,ν,ա,×,ყ,২,ձ,ъ,ƈ,ժ,ε,բ,ց,հ,ﻨ,յ,ĸ,l,ო,ռ,օ,թ,զ,г,ร,է,ս,ν,ա,×,ყ,২,0,9,8,7,6,5,4,3,2,1,.,_",
				  "Â,ß,Ĉ,Ð,Є,Ŧ,Ǥ,Ħ,Ī,ʖ,Қ,Ŀ,♏,И,Ø,P,Ҩ,R,$,ƚ,Ц,V,Щ,X,￥,Ẕ,Â,ß,Ĉ,Ð,Є,Ŧ,Ǥ,Ħ,Ī,ʖ,Қ,Ŀ,♏,И,Ø,P,Ҩ,R,$,ƚ,Ц,V,Щ,X,￥,Ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
				  "Λ,ɓ,¢,Ɗ,£,ƒ,ɢ,ɦ,ĩ,ʝ,Қ,Ł,ɱ,ה,ø,Ṗ,Ҩ,Ŕ,Ş,Ŧ,Ū,Ɣ,ω,Ж,¥,Ẑ,Λ,ɓ,¢,Ɗ,£,ƒ,ɢ,ɦ,ĩ,ʝ,Қ,Ł,ɱ,ה,ø,Ṗ,Ҩ,Ŕ,Ş,Ŧ,Ū,Ɣ,ω,Ж,¥,Ẑ,0,9,8,7,6,5,4,3,2,1,.,_",
				  "Λ,Б,Ͼ,Ð,Ξ,Ŧ,G,H,ł,J,К,Ł,M,Л,Ф,P,Ǫ,Я,S,T,U,V,Ш,Ж,Џ,Z,Λ,Б,Ͼ,Ð,Ξ,Ŧ,g,h,ł,j,К,Ł,m,Л,Ф,p,Ǫ,Я,s,t,u,v,Ш,Ж,Џ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "Թ,Յ,Շ,Ժ,ȝ,Բ,Գ,ɧ,ɿ,ʝ,ƙ,ʅ,ʍ,Ռ,Ծ,ρ,φ,Ր,Տ,Ե,Մ,ע,ա,Ճ,Վ,Հ,Թ,Յ,Շ,Ժ,ȝ,Բ,Գ,ɧ,ɿ,ʝ,ƙ,ʅ,ʍ,Ռ,Ծ,ρ,φ,Ր,Տ,Ե,Մ,ע,ա,Ճ,Վ,Հ,0,9,8,7,6,5,4,3,2,1,.,_",
				  "Æ,þ,©,Ð,E,F,ζ,Ħ,Ї,¿,ズ,ᄂ,M,Ñ,Θ,Ƿ,Ø,Ґ,Š,τ,υ,¥,w,χ,y,շ,Æ,þ,©,Ð,E,F,ζ,Ħ,Ї,¿,ズ,ᄂ,M,Ñ,Θ,Ƿ,Ø,Ґ,Š,τ,υ,¥,w,χ,y,շ,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ɐ,q,ɔ,p,ǝ,ɟ,ɓ,ɥ,ı,ſ,ʞ,ๅ,ɯ,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,ɐ,q,ɔ,p,ǝ,ɟ,ɓ,ɥ,ı,ſ,ʞ,ๅ,ɯ,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "ɒ,d,ɔ,b,ɘ,ʇ,ϱ,н,i,į,ʞ,l,м,и,o,q,p,я,ƨ,т,υ,v,w,x,γ,z,ɒ,d,ɔ,b,ɘ,ʇ,ϱ,н,i,į,ʞ,l,м,и,o,q,p,я,ƨ,т,υ,v,w,x,γ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "4,8,C,D,3,F,9,H,!,J,K,1,M,N,0,P,Q,R,5,7,U,V,W,X,Y,2,4,8,C,D,3,F,9,H,!,J,K,1,M,N,0,P,Q,R,5,7,U,V,W,X,Y,2,0,9,8,7,6,5,4,3,2,1,.,_",
				  "Λ,M,X,ʎ,Z,ɐ,q,ɔ,p,ǝ,ɟ,ƃ,ɥ,ı,ɾ,ʞ,l,ա,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,Λ,M,X,ʎ,Z,ɐ,q,ɔ,p,ǝ,ɟ,ƃ,ɥ,ı,ɾ,ʞ,l,ա,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,0,9,8,7,6,5,4,3,2,1,.,‾",
				  "A̴,̴B̴,̴C̴,̴D̴,̴E̴,̴F̴,̴G̴,̴H̴,̴I̴,̴J̴,̴K̴,̴L̴,̴M̴,̴N̴,̴O̴,̴P̴,̴Q̴,̴R̴,̴S̴,̴T̴,̴U̴,̴V̴,̴W̴,̴X̴,̴Y̴,̴Z̴,̴a̴,̴b̴,̴c̴,̴d̴,̴e̴,̴f̴,̴g̴,̴h̴,̴i̴,̴j̴,̴k̴,̴l̴,̴m̴,̴n̴,̴o̴,̴p̴,̴q̴,̴r̴,̴s̴,̴t̴,̴u̴,̴v̴,̴w̴,̴x̴,̴y̴,̴z̴,̴0̴,̴9̴,̴8̴,̴7̴,̴6̴,̴5̴,̴4̴,̴3̴,̴2̴,̴1̴,̴.̴,̴_̴",
				  "A̱,̱Ḇ,̱C̱,̱Ḏ,̱E̱,̱F̱,̱G̱,̱H̱,̱I̱,̱J̱,̱Ḵ,̱Ḻ,̱M̱,̱Ṉ,̱O̱,̱P̱,̱Q̱,̱Ṟ,̱S̱,̱Ṯ,̱U̱,̱V̱,̱W̱,̱X̱,̱Y̱,̱Ẕ,̱a̱,̱ḇ,̱c̱,̱ḏ,̱e̱,̱f̱,̱g̱,̱ẖ,̱i̱,̱j̱,̱ḵ,̱ḻ,̱m̱,̱ṉ,̱o̱,̱p̱,̱q̱,̱ṟ,̱s̱,̱ṯ,̱u̱,̱v̱,̱w̱,̱x̱,̱y̱,̱ẕ,̱0̱,̱9̱,̱8̱,̱7̱,̱6̱,̱5̱,̱4̱,̱3̱,̱2̱,̱1̱,̱.̱,̱_̱",
				  "A̲,̲B̲,̲C̲,̲D̲,̲E̲,̲F̲,̲G̲,̲H̲,̲I̲,̲J̲,̲K̲,̲L̲,̲M̲,̲N̲,̲O̲,̲P̲,̲Q̲,̲R̲,̲S̲,̲T̲,̲U̲,̲V̲,̲W̲,̲X̲,̲Y̲,̲Z̲,̲a̲,̲b̲,̲c̲,̲d̲,̲e̲,̲f̲,̲g̲,̲h̲,̲i̲,̲j̲,̲k̲,̲l̲,̲m̲,̲n̲,̲o̲,̲p̲,̲q̲,̲r̲,̲s̲,̲t̲,̲u̲,̲v̲,̲w̲,̲x̲,̲y̲,̲z̲,̲0̲,̲9̲,̲8̲,̲7̲,̲6̲,̲5̲,̲4̲,̲3̲,̲2̲,̲1̲,̲.̲,̲_̲",
				  "Ā,̄B̄,̄C̄,̄D̄,̄Ē,̄F̄,̄Ḡ,̄H̄,̄Ī,̄J̄,̄K̄,̄L̄,̄M̄,̄N̄,̄Ō,̄P̄,̄Q̄,̄R̄,̄S̄,̄T̄,̄Ū,̄V̄,̄W̄,̄X̄,̄Ȳ,̄Z̄,̄ā,̄b̄,̄c̄,̄d̄,̄ē,̄f̄,̄ḡ,̄h̄,̄ī,̄j̄,̄k̄,̄l̄,̄m̄,̄n̄,̄ō,̄p̄,̄q̄,̄r̄,̄s̄,̄t̄,̄ū,̄v̄,̄w̄,̄x̄,̄ȳ,̄z̄,̄0̄,̄9̄,̄8̄,̄7̄,̄6̄,̄5̄,̄4̄,̄3̄,̄2̄,̄1̄,̄.̄,̄_̄",
				  "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,9,8,7,6,5,4,3,2,1,.,_",
				  "@,♭,ḉ,ⓓ,℮,ƒ,ℊ,ⓗ,ⓘ,נ,ⓚ,ℓ,ⓜ,η,ø,℘,ⓠ,ⓡ,﹩,т,ⓤ,√,ω,ж,૪,ℨ,@,♭,ḉ,ⓓ,℮,ƒ,ℊ,ⓗ,ⓘ,נ,ⓚ,ℓ,ⓜ,η,ø,℘,ⓠ,ⓡ,﹩,т,ⓤ,√,ω,ж,૪,ℨ,0,➈,➑,➐,➅,➄,➃,➌,➁,➊,.,_",
				  "@,♭,¢,ⅾ,ε,ƒ,ℊ,ℌ,ї,נ,к,ℓ,м,п,ø,ρ,ⓠ,ґ,﹩,⊥,ü,√,ω,ϰ,૪,ℨ,@,♭,¢,ⅾ,ε,ƒ,ℊ,ℌ,ї,נ,к,ℓ,м,п,ø,ρ,ⓠ,ґ,﹩,⊥,ü,√,ω,ϰ,૪,ℨ,0,9,8,7,6,5,4,3,2,1,.,_",
				  "α,♭,ḉ,∂,ℯ,ƒ,ℊ,ℌ,ї,ʝ,ḱ,ℓ,м,η,ø,℘,ⓠ,я,﹩,⊥,ц,ṽ,ω,ჯ,૪,ẕ,α,♭,ḉ,∂,ℯ,ƒ,ℊ,ℌ,ї,ʝ,ḱ,ℓ,м,η,ø,℘,ⓠ,я,﹩,⊥,ц,ṽ,ω,ჯ,૪,ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
				  "@,ß,¢,ḓ,℮,ƒ,ℊ,ℌ,ї,נ,ḱ,ʟ,м,п,◎,℘,ⓠ,я,﹩,т,ʊ,♥️,ẘ,✄,૪,ℨ,@,ß,¢,ḓ,℮,ƒ,ℊ,ℌ,ї,נ,ḱ,ʟ,м,п,◎,℘,ⓠ,я,﹩,т,ʊ,♥️,ẘ,✄,૪,ℨ,0,9,8,7,6,5,4,3,2,1,.,_",
					  "@,ß,¢,ḓ,℮,ƒ,ℊ,н,ḯ,נ,к,ℓμ,п,☺️,℘,ⓠ,я,﹩,⊥,υ,ṽ,ω,✄,૪,ℨ,@,ß,¢,ḓ,℮,ƒ,ℊ,н,ḯ,נ,к,ℓμ,п,☺️,℘,ⓠ,я,﹩,⊥,υ,ṽ,ω,✄,૪,ℨ,0,9,8,7,6,5,4,3,2,1,.,_",
					  "@,ß,ḉ,ḓ,є,ƒ,ℊ,ℌ,ї,נ,ḱ,ʟ,ღ,η,◎,℘,ⓠ,я,﹩,⊥,ʊ,♥️,ω,ϰ,૪,ẕ,@,ß,ḉ,ḓ,є,ƒ,ℊ,ℌ,ї,נ,ḱ,ʟ,ღ,η,◎,℘,ⓠ,я,﹩,⊥,ʊ,♥️,ω,ϰ,૪,ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
					  "@,ß,ḉ,∂,ε,ƒ,ℊ,ℌ,ї,נ,ḱ,ł,ღ,и,ø,℘,ⓠ,я,﹩,т,υ,√,ω,ჯ,૪,ẕ,@,ß,ḉ,∂,ε,ƒ,ℊ,ℌ,ї,נ,ḱ,ł,ღ,и,ø,℘,ⓠ,я,﹩,т,υ,√,ω,ჯ,૪,ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
					  "α,♭,¢,∂,ε,ƒ,❡,н,ḯ,ʝ,ḱ,ʟ,μ,п,ø,ρ,ⓠ,ґ,﹩,т,υ,ṽ,ω,ж,૪,ẕ,α,♭,¢,∂,ε,ƒ,❡,н,ḯ,ʝ,ḱ,ʟ,μ,п,ø,ρ,ⓠ,ґ,﹩,т,υ,ṽ,ω,ж,૪,ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
					  "α,♭,ḉ,∂,℮,ⓕ,ⓖ,н,ḯ,ʝ,ḱ,ℓ,м,п,ø,ⓟ,ⓠ,я,ⓢ,ⓣ,ⓤ,♥️,ⓦ,✄,ⓨ,ⓩ,α,♭,ḉ,∂,℮,ⓕ,ⓖ,н,ḯ,ʝ,ḱ,ℓ,м,п,ø,ⓟ,ⓠ,я,ⓢ,ⓣ,ⓤ,♥️,ⓦ,✄,ⓨ,ⓩ,0,➒,➑,➐,➏,➄,➍,➂,➁,➀,.,_",
					  "@,♭,ḉ,ḓ,є,ƒ,ⓖ,ℌ,ⓘ,נ,к,ⓛ,м,ⓝ,ø,℘,ⓠ,я,﹩,ⓣ,ʊ,√,ω,ჯ,૪,ⓩ,@,♭,ḉ,ḓ,є,ƒ,ⓖ,ℌ,ⓘ,נ,к,ⓛ,м,ⓝ,ø,℘,ⓠ,я,﹩,ⓣ,ʊ,√,ω,ჯ,૪,ⓩ,0,➒,➇,➆,➅,➄,➍,➌,➋,➀,.,_",
					  "α,♭,ⓒ,∂,є,ⓕ,ⓖ,ℌ,ḯ,ⓙ,ḱ,ł,ⓜ,и,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,⊥,ʊ,ⓥ,ⓦ,ж,ⓨ,ⓩ,α,♭,ⓒ,∂,є,ⓕ,ⓖ,ℌ,ḯ,ⓙ,ḱ,ł,ⓜ,и,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,⊥,ʊ,ⓥ,ⓦ,ж,ⓨ,ⓩ,0,➒,➑,➆,➅,➎,➍,➌,➁,➀,.,_",
				  "ⓐ,ß,ḉ,∂,℮,ⓕ,❡,ⓗ,ї,נ,ḱ,ł,μ,η,ø,ρ,ⓠ,я,﹩,ⓣ,ц,√,ⓦ,✖️,૪,ℨ,ⓐ,ß,ḉ,∂,℮,ⓕ,❡,ⓗ,ї,נ,ḱ,ł,μ,η,ø,ρ,ⓠ,я,﹩,ⓣ,ц,√,ⓦ,✖️,૪,ℨ,0,➒,➑,➐,➅,➄,➍,➂,➁,➊,.,_",
					  "α,ß,ⓒ,ⅾ,ℯ,ƒ,ℊ,ⓗ,ї,ʝ,к,ʟ,ⓜ,η,ⓞ,℘,ⓠ,ґ,﹩,т,υ,ⓥ,ⓦ,ж,ⓨ,ẕ,α,ß,ⓒ,ⅾ,ℯ,ƒ,ℊ,ⓗ,ї,ʝ,к,ʟ,ⓜ,η,ⓞ,℘,ⓠ,ґ,﹩,т,υ,ⓥ,ⓦ,ж,ⓨ,ẕ,0,➈,➇,➐,➅,➎,➍,➌,➁,➊,.,_",
					  "@,♭,ḉ,ⅾ,є,ⓕ,❡,н,ḯ,נ,ⓚ,ⓛ,м,ⓝ,☺️,ⓟ,ⓠ,я,ⓢ,⊥,υ,♥️,ẘ,ϰ,૪,ⓩ,@,♭,ḉ,ⅾ,є,ⓕ,❡,н,ḯ,נ,ⓚ,ⓛ,м,ⓝ,☺️,ⓟ,ⓠ,я,ⓢ,⊥,υ,♥️,ẘ,ϰ,૪,ⓩ,0,➒,➑,➆,➅,➄,➃,➂,➁,➀,.,_",
					  "ⓐ,♭,ḉ,ⅾ,є,ƒ,ℊ,ℌ,ḯ,ʝ,ḱ,ł,μ,η,ø,ⓟ,ⓠ,ґ,ⓢ,т,ⓤ,√,ⓦ,✖️,ⓨ,ẕ,ⓐ,♭,ḉ,ⅾ,є,ƒ,ℊ,ℌ,ḯ,ʝ,ḱ,ł,μ,η,ø,ⓟ,ⓠ,ґ,ⓢ,т,ⓤ,√,ⓦ,✖️,ⓨ,ẕ,0,➈,➇,➐,➅,➄,➃,➂,➁,➀,.,_",
				  "ձ,ъƈ,ժ,ε,բ,ց,հ,ﻨ,յ,ĸ,l,ო,ռ,օ,թ,զ,г,ร,է,ս,ν,ա,×,ყ,২,ձ,ъƈ,ժ,ε,բ,ց,հ,ﻨ,յ,ĸ,l,ო,ռ,օ,թ,զ,г,ร,է,ս,ν,ա,×,ყ,২,0,9,8,7,6,5,4,3,2,1,.,_",
				"λ,ϐ,ς,d,ε,ғ,ϑ,ɢ,н,ι,ϳ,κ,l,ϻ,π,σ,ρ,φ,г,s,τ,υ,v,ш,ϰ,ψ,z,λ,ϐ,ς,d,ε,ғ,ϑ,ɢ,н,ι,ϳ,κ,l,ϻ,π,σ,ρ,φ,г,s,τ,υ,v,ш,ϰ,ψ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				"ค,๒,ς,๔,є,Ŧ,ɠ,ђ,เ,ן,к,l,๓,ภ,๏,թ,ợ,г,ร,t,ย,v,ฬ,x,ץ,z,ค,๒,ς,๔,є,Ŧ,ɠ,ђ,เ,ן,к,l,๓,ภ,๏,թ,ợ,г,ร,t,ย,v,ฬ,x,ץ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				"მ,ჩ,ƈძ,ε,բ,ց,հ,ἶ,ʝ,ƙ,l,ო,ղ,օ,ր,գ,ɾ,ʂ,է,մ,ν,ω,ჯ,ყ,z,მ,ჩ,ƈძ,ε,բ,ց,հ,ἶ,ʝ,ƙ,l,ო,ղ,օ,ր,գ,ɾ,ʂ,է,մ,ν,ω,ჯ,ყ,z,0,Գ,Ց,Դ,6,5,Վ,Յ,Զ,1,.,_",
				"ค,ც,८,ძ,૯,Բ,૭,Һ,ɿ,ʆ,қ,Ն,ɱ,Ո,૦,ƿ,ҩ,Ր,ς,੮,υ,౮,ω,૪,ע,ઽ,ค,ც,८,ძ,૯,Բ,૭,Һ,ɿ,ʆ,қ,Ն,ɱ,Ո,૦,ƿ,ҩ,Ր,ς,੮,υ,౮,ω,૪,ע,ઽ,0,9,8,7,6,5,4,3,2,1,.,_",
				"Λ,Б,Ͼ,Ð,Ξ,Ŧ,g,h,ł,j,К,Ł,m,Л,Ф,p,Ǫ,Я,s,t,u,v,Ш,Ж,Џ,z,Λ,Б,Ͼ,Ð,Ξ,Ŧ,g,h,ł,j,К,Ł,m,Л,Ф,p,Ǫ,Я,s,t,u,v,Ш,Ж,Џ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				"λ,ß,Ȼ,ɖ,ε,ʃ,Ģ,ħ,ί,ĵ,κ,ι,ɱ,ɴ,Θ,ρ,ƣ,ર,Ș,τ,Ʋ,ν,ώ,Χ,ϓ,Հ,λ,ß,Ȼ,ɖ,ε,ʃ,Ģ,ħ,ί,ĵ,κ,ι,ɱ,ɴ,Θ,ρ,ƣ,ર,Ș,τ,Ʋ,ν,ώ,Χ,ϓ,Հ,0,9,8,7,6,5,4,3,2,1,.,_",
				"ª,b,¢,Þ,È,F,૬,ɧ,Î,j,Κ,Ļ,м,η,◊,Ƿ,ƍ,r,S,⊥,µ,√,w,×,ý,z,ª,b,¢,Þ,È,F,૬,ɧ,Î,j,Κ,Ļ,м,η,◊,Ƿ,ƍ,r,S,⊥,µ,√,w,×,ý,z,0,9,8,7,6,5,4,3,2,1,.,_",
				"Թ,Յ,Շ,Ժ,ȝ,Բ,Գ,ɧ,ɿ,ʝ,ƙ,ʅ,ʍ,Ռ,Ծ,ρ,φ,Ր,Տ,Ե,Մ,ע,ա,Ճ,Վ,Հ,Թ,Յ,Շ,Ժ,ȝ,Բ,Գ,ɧ,ɿ,ʝ,ƙ,ʅ,ʍ,Ռ,Ծ,ρ,φ,Ր,Տ,Ե,Մ,ע,ա,Ճ,Վ,Հ,0,9,8,7,6,5,4,3,2,1,.,_",
				"Λ,Ϧ,ㄈ,Ð,Ɛ,F,Ɠ,н,ɪ,ﾌ,Қ,Ł,௱,Л,Ø,þ,Ҩ,尺,ら,Ť,Ц,Ɣ,Ɯ,χ,Ϥ,Ẕ,Λ,Ϧ,ㄈ,Ð,Ɛ,F,Ɠ,н,ɪ,ﾌ,Қ,Ł,௱,Л,Ø,þ,Ҩ,尺,ら,Ť,Ц,Ɣ,Ɯ,χ,Ϥ,Ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
				"Ǟ,в,ट,D,ę,բ,g,৸,i,j,κ,l,ɱ,П,Φ,Р,q,Я,s,Ʈ,Ц,v,Щ,ж,ყ,ւ,Ǟ,в,ट,D,ę,բ,g,৸,i,j,κ,l,ɱ,П,Φ,Р,q,Я,s,Ʈ,Ц,v,Щ,ж,ყ,ւ,0,9,8,7,6,5,4,3,2,1,.,_",
				"ɒ,d,ɔ,b,ɘ,ʇ,ϱ,н,i,į,ʞ,l,м,и,o,q,p,я,ƨ,т,υ,v,w,x,γ,z,ɒ,d,ɔ,b,ɘ,ʇ,ϱ,н,i,į,ʞ,l,м,и,o,q,p,я,ƨ,т,υ,v,w,x,γ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				"Æ,þ,©,Ð,E,F,ζ,Ħ,Ї,¿,ズ,ᄂ,M,Ñ,Θ,Ƿ,Ø,Ґ,Š,τ,υ,¥,w,χ,y,շ,Æ,þ,©,Ð,E,F,ζ,Ħ,Ї,¿,ズ,ᄂ,M,Ñ,Θ,Ƿ,Ø,Ґ,Š,τ,υ,¥,w,χ,y,շ,0,9,8,7,6,5,4,3,2,1,.,_",
				"ª,ß,¢,ð,€,f,g,h,¡,j,k,|,m,ñ,¤,Þ,q,®,$,t,µ,v,w,×,ÿ,z,ª,ß,¢,ð,€,f,g,h,¡,j,k,|,m,ñ,¤,Þ,q,®,$,t,µ,v,w,×,ÿ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				"ɐ,q,ɔ,p,ǝ,ɟ,ɓ,ɥ,ı,ſ,ʞ,ๅ,ɯ,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,ɐ,q,ɔ,p,ǝ,ɟ,ɓ,ɥ,ı,ſ,ʞ,ๅ,ɯ,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,0,9,8,7,6,5,4,3,2,1,.,_",
				"⒜,⒝,⒞,⒟,⒠,⒡,⒢,⒣,⒤,⒥,⒦,⒧,⒨,⒩,⒪,⒫,⒬,⒭,⒮,⒯,⒰,⒱,⒲,⒳,⒴,⒵,⒜,⒝,⒞,⒟,⒠,⒡,⒢,⒣,⒤,⒥,⒦,⒧,⒨,⒩,⒪,⒫,⒬,⒭,⒮,⒯,⒰,⒱,⒲,⒳,⒴,⒵,⒪,⑼,⑻,⑺,⑹,⑸,⑷,⑶,⑵,⑴,.,_",
				"ɑ,ʙ,c,ᴅ,є,ɻ,მ,ʜ,ι,ɿ,ĸ,г,w,и,o,ƅϭ,ʁ,ƨ,⊥,n,ʌ,ʍ,x,⑃,z,ɑ,ʙ,c,ᴅ,є,ɻ,მ,ʜ,ι,ɿ,ĸ,г,w,и,o,ƅϭ,ʁ,ƨ,⊥,n,ʌ,ʍ,x,⑃,z,0,9,8,7,6,5,4,3,2,1,.,_",
				"4,8,C,D,3,F,9,H,!,J,K,1,M,N,0,P,Q,R,5,7,U,V,W,X,Y,2,4,8,C,D,3,F,9,H,!,J,K,1,M,N,0,P,Q,R,5,7,U,V,W,X,Y,2,0,9,8,7,6,5,4,3,2,1,.,_",
				"Λ,ßƇ,D,Ɛ,F,Ɠ,Ĥ,Ī,Ĵ,Ҡ,Ŀ,M,И,♡,Ṗ,Ҩ,Ŕ,S,Ƭ,Ʊ,Ѵ,Ѡ,Ӿ,Y,Z,Λ,ßƇ,D,Ɛ,F,Ɠ,Ĥ,Ī,Ĵ,Ҡ,Ŀ,M,И,♡,Ṗ,Ҩ,Ŕ,S,Ƭ,Ʊ,Ѵ,Ѡ,Ӿ,Y,Z,0,9,8,7,6,5,4,3,2,1,.,_",
				"α,в,¢,đ,e,f,g,ħ,ı,נ,κ,ł,м,и,ø,ρ,q,я,š,т,υ,ν,ω,χ,ч,z,α,в,¢,đ,e,f,g,ħ,ı,נ,κ,ł,м,и,ø,ρ,q,я,š,т,υ,ν,ω,χ,ч,z,0,9,8,7,6,5,4,3,2,1,.,_",
				"α,в,c,ɔ,ε,ғ,ɢ,н,ı,נ,κ,ʟ,м,п,σ,ρ,ǫ,я,ƨ,т,υ,ν,ш,х,ч,z,α,в,c,ɔ,ε,ғ,ɢ,н,ı,נ,κ,ʟ,м,п,σ,ρ,ǫ,я,ƨ,т,υ,ν,ш,х,ч,z,0,9,8,7,6,5,4,3,2,1,.,_",
				"【a】,【b】,【c】,【d】,【e】,【f】,【g】,【h】,【i】,【j】,【k】,【l】,【m】,【n】,【o】,【p】,【q】,【r】,【s】,【t】,【u】,【v】,【w】,【x】,【y】,【z】,【a】,【b】,【c】,【d】,【e】,【f】,【g】,【h】,【i】,【j】,【k】,【l】,【m】,【n】,【o】,【p】,【q】,【r】,【s】,【t】,【u】,【v】,【w】,【x】,【y】,【z】,【0】,【9】,【8】,【7】,【6】,【5】,【4】,【3】,【2】,【1】,.,_",
				"[̲̲̅̅a̲̅,̲̅b̲̲̅,̅c̲̅,̲̅d̲̲̅,̅e̲̲̅,̅f̲̲̅,̅g̲̅,̲̅h̲̲̅,̅i̲̲̅,̅j̲̲̅,̅k̲̅,̲̅l̲̲̅,̅m̲̅,̲̅n̲̅,̲̅o̲̲̅,̅p̲̅,̲̅q̲̅,̲̅r̲̲̅,̅s̲̅,̲̅t̲̲̅,̅u̲̅,̲̅v̲̅,̲̅w̲̅,̲̅x̲̅,̲̅y̲̅,̲̅z̲̅,[̲̲̅̅a̲̅,̲̅b̲̲̅,̅c̲̅,̲̅d̲̲̅,̅e̲̲̅,̅f̲̲̅,̅g̲̅,̲̅h̲̲̅,̅i̲̲̅,̅j̲̲̅,̅k̲̅,̲̅l̲̲̅,̅m̲̅,̲̅n̲̅,̲̅o̲̲̅,̅p̲̅,̲̅q̲̅,̲̅r̲̲̅,̅s̲̅,̲̅t̲̲̅,̅u̲̅,̲̅v̲̅,̲̅w̲̅,̲̅x̲̅,̲̅y̲̅,̲̅z̲̅,̲̅0̲̅,̲̅9̲̲̅,̅8̲̅,̲̅7̲̅,̲̅6̲̅,̲̅5̲̅,̲̅4̲̅,̲̅3̲̲̅,̅2̲̲̅,̅1̲̲̅̅],.,_",
				"[̺͆a̺͆͆,̺b̺͆͆,̺c̺͆,̺͆d̺͆,̺͆e̺͆,̺͆f̺͆͆,̺g̺͆,̺͆h̺͆,̺͆i̺͆,̺͆j̺͆,̺͆k̺͆,̺l̺͆͆,̺m̺͆͆,̺n̺͆͆,̺o̺͆,̺͆p̺͆͆,̺q̺͆͆,̺r̺͆͆,̺s̺͆͆,̺t̺͆͆,̺u̺͆͆,̺v̺͆͆,̺w̺͆,̺͆x̺͆,̺͆y̺͆,̺͆z̺,[̺͆a̺͆͆,̺b̺͆͆,̺c̺͆,̺͆d̺͆,̺͆e̺͆,̺͆f̺͆͆,̺g̺͆,̺͆h̺͆,̺͆i̺͆,̺͆j̺͆,̺͆k̺͆,̺l̺͆͆,̺m̺͆͆,̺n̺͆͆,̺o̺͆,̺͆p̺͆͆,̺q̺͆͆,̺r̺͆͆,̺s̺͆͆,̺t̺͆͆,̺u̺͆͆,̺v̺͆͆,̺w̺͆,̺͆x̺͆,̺͆y̺͆,̺͆z̺,̺͆͆0̺͆,̺͆9̺͆,̺͆8̺̺͆͆7̺͆,̺͆6̺͆,̺͆5̺͆,̺͆4̺͆,̺͆3̺͆,̺͆2̺͆,̺͆1̺͆],.,_",
				"̛̭̰̃ã̛̰̭,̛̭̰̃b̛̰̭̃̃,̛̭̰c̛̛̰̭̃̃,̭̰d̛̰̭̃,̛̭̰̃ḛ̛̭̃̃,̛̭̰f̛̰̭̃̃,̛̭̰g̛̰̭̃̃,̛̭̰h̛̰̭̃,̛̭̰̃ḭ̛̛̭̃̃,̭̰j̛̰̭̃̃,̛̭̰k̛̰̭̃̃,̛̭̰l̛̰̭,̛̭̰̃m̛̰̭̃̃,̛̭̰ñ̛̛̰̭̃,̭̰ỡ̰̭̃,̛̭̰p̛̰̭̃,̛̭̰̃q̛̰̭̃̃,̛̭̰r̛̛̰̭̃̃,̭̰s̛̰̭,̛̭̰̃̃t̛̰̭̃,̛̭̰̃ữ̰̭̃,̛̭̰ṽ̛̰̭̃,̛̭̰w̛̛̰̭̃̃,̭̰x̛̰̭̃,̛̭̰̃ỹ̛̰̭̃,̛̭̰z̛̰̭̃̃,̛̛̭̰ã̛̰̭,̛̭̰̃b̛̰̭̃̃,̛̭̰c̛̛̰̭̃̃,̭̰d̛̰̭̃,̛̭̰̃ḛ̛̭̃̃,̛̭̰f̛̰̭̃̃,̛̭̰g̛̰̭̃̃,̛̭̰h̛̰̭̃,̛̭̰̃ḭ̛̛̭̃̃,̭̰j̛̰̭̃̃,̛̭̰k̛̰̭̃̃,̛̭̰l̛̰̭,̛̭̰̃m̛̰̭̃̃,̛̭̰ñ̛̛̰̭̃,̭̰ỡ̰̭̃,̛̭̰p̛̰̭̃,̛̭̰̃q̛̰̭̃̃,̛̭̰r̛̛̰̭̃̃,̭̰s̛̰̭,̛̭̰̃̃t̛̰̭̃,̛̭̰̃ữ̰̭̃,̛̭̰ṽ̛̰̭̃,̛̭̰w̛̛̰̭̃̃,̭̰x̛̰̭̃,̛̭̰̃ỹ̛̰̭̃,̛̭̰z̛̰̭̃̃,̛̭̰0̛̛̰̭̃̃,̭̰9̛̰̭̃̃,̛̭̰8̛̛̰̭̃̃,̭̰7̛̰̭̃̃,̛̭̰6̛̰̭̃̃,̛̭̰5̛̰̭̃,̛̭̰̃4̛̰̭̃,̛̭̰̃3̛̰̭̃̃,̛̭̰2̛̰̭̃̃,̛̭̰1̛̰̭̃,.,_",
				"a,ะb,ะc,ะd,ะe,ะf,ะg,ะh,ะi,ะj,ะk,ะl,ะm,ะn,ะo,ะp,ะq,ะr,ะs,ะt,ะu,ะv,ะw,ะx,ะy,ะz,a,ะb,ะc,ะd,ะe,ะf,ะg,ะh,ะi,ะj,ะk,ะl,ะm,ะn,ะo,ะp,ะq,ะr,ะs,ะt,ะu,ะv,ะw,ะx,ะy,ะz,ะ0,ะ9,ะ8,ะ7,ะ6,ะ5,ะ4,ะ3,ะ2,ะ1ะ,.,_",
				"̑ȃ,̑b̑,̑c̑,̑d̑,̑ȇ,̑f̑,̑g̑,̑h̑,̑ȋ,̑j̑,̑k̑,̑l̑,̑m̑,̑n̑,̑ȏ,̑p̑,̑q̑,̑ȓ,̑s̑,̑t̑,̑ȗ,̑v̑,̑w̑,̑x̑,̑y̑,̑z̑,̑ȃ,̑b̑,̑c̑,̑d̑,̑ȇ,̑f̑,̑g̑,̑h̑,̑ȋ,̑j̑,̑k̑,̑l̑,̑m̑,̑n̑,̑ȏ,̑p̑,̑q̑,̑ȓ,̑s̑,̑t̑,̑ȗ,̑v̑,̑w̑,̑x̑,̑y̑,̑z̑,̑0̑,̑9̑,̑8̑,̑7̑,̑6̑,̑5̑,̑4̑,̑3̑,̑2̑,̑1̑,.,_",
				"~a,͜͝b,͜͝c,͜͝d,͜͝e,͜͝f,͜͝g,͜͝h,͜͝i,͜͝j,͜͝k,͜͝l,͜͝m,͜͝n,͜͝o,͜͝p,͜͝q,͜͝r,͜͝s,͜͝t,͜͝u,͜͝v,͜͝w,͜͝x,͜͝y,͜͝z,~a,͜͝b,͜͝c,͜͝d,͜͝e,͜͝f,͜͝g,͜͝h,͜͝i,͜͝j,͜͝k,͜͝l,͜͝m,͜͝n,͜͝o,͜͝p,͜͝q,͜͝r,͜͝s,͜͝t,͜͝u,͜͝v,͜͝w,͜͝x,͜͝y,͜͝z,͜͝0,͜͝9,͜͝8,͜͝7,͜͝6,͜͝5,͜͝4,͜͝3,͜͝2͜,͝1͜͝~,.,_",
				"̤̈ä̤,̤̈b̤̈,̤̈c̤̈̈,̤d̤̈,̤̈ë̤,̤̈f̤̈,̤̈g̤̈̈,̤ḧ̤̈,̤ï̤̈,̤j̤̈,̤̈k̤̈̈,̤l̤̈,̤̈m̤̈,̤̈n̤̈,̤̈ö̤,̤̈p̤̈,̤̈q̤̈,̤̈r̤̈,̤̈s̤̈̈,̤ẗ̤̈,̤ṳ̈,̤̈v̤̈,̤̈ẅ̤,̤̈ẍ̤,̤̈ÿ̤,̤̈z̤̈,̤̈ä̤,̤̈b̤̈,̤̈c̤̈̈,̤d̤̈,̤̈ë̤,̤̈f̤̈,̤̈g̤̈̈,̤ḧ̤̈,̤ï̤̈,̤j̤̈,̤̈k̤̈̈,̤l̤̈,̤̈m̤̈,̤̈n̤̈,̤̈ö̤,̤̈p̤̈,̤̈q̤̈,̤̈r̤̈,̤̈s̤̈̈,̤ẗ̤̈,̤ṳ̈,̤̈v̤̈,̤̈ẅ̤,̤̈ẍ̤,̤̈ÿ̤,̤̈z̤̈,̤̈0̤̈,̤̈9̤̈,̤̈8̤̈,̤̈7̤̈,̤̈6̤̈,̤̈5̤̈,̤̈4̤̈,̤̈3̤̈,̤̈2̤̈̈,̤1̤̈,.,_",
				"≋̮̑ȃ̮,̮̑b̮̑,̮̑c̮̑,̮̑d̮̑,̮̑ȇ̮,̮̑f̮̑,̮̑g̮̑,̮̑ḫ̑,̮̑ȋ̮,̮̑j̮̑,̮̑k̮̑,̮̑l̮̑,̮̑m̮̑,̮̑n̮̑,̮̑ȏ̮,̮̑p̮̑,̮̑q̮̑,̮̑r̮,̮̑̑s̮,̮̑̑t̮,̮̑̑u̮,̮̑̑v̮̑,̮̑w̮̑,̮̑x̮̑,̮̑y̮̑,̮̑z̮̑,≋̮̑ȃ̮,̮̑b̮̑,̮̑c̮̑,̮̑d̮̑,̮̑ȇ̮,̮̑f̮̑,̮̑g̮̑,̮̑ḫ̑,̮̑ȋ̮,̮̑j̮̑,̮̑k̮̑,̮̑l̮̑,̮̑m̮̑,̮̑n̮̑,̮̑ȏ̮,̮̑p̮̑,̮̑q̮̑,̮̑r̮,̮̑̑s̮,̮̑̑t̮,̮̑̑u̮,̮̑̑v̮̑,̮̑w̮̑,̮̑x̮̑,̮̑y̮̑,̮̑z̮̑,̮̑0̮̑,̮̑9̮̑,̮̑8̮̑,̮̑7̮̑,̮̑6̮̑,̮̑5̮̑,̮̑4̮̑,̮̑3̮̑,̮̑2̮̑,̮̑1̮̑≋,.,_",
				"a̮,̮b̮̮,c̮̮,d̮̮,e̮̮,f̮̮,g̮̮,ḫ̮,i̮,j̮̮,k̮̮,l̮,̮m̮,̮n̮̮,o̮,̮p̮̮,q̮̮,r̮̮,s̮,̮t̮̮,u̮̮,v̮̮,w̮̮,x̮̮,y̮̮,z̮̮,a̮,̮b̮̮,c̮̮,d̮̮,e̮̮,f̮̮,g̮̮,ḫ̮i,̮̮,j̮̮,k̮̮,l̮,̮m̮,̮n̮̮,o̮,̮p̮̮,q̮̮,r̮̮,s̮,̮t̮̮,u̮̮,v̮̮,w̮̮,x̮̮,y̮̮,z̮̮,0̮̮,9̮̮,8̮̮,7̮̮,6̮̮,5̮̮,4̮̮,3̮̮,2̮̮,1̮,.,_",
				"A̲,̲B̲,̲C̲,̲D̲,̲E̲,̲F̲,̲G̲,̲H̲,̲I̲,̲J̲,̲K̲,̲L̲,̲M̲,̲N̲,̲O̲,̲P̲,̲Q̲,̲R̲,̲S̲,̲T̲,̲U̲,̲V̲,̲W̲,̲X̲,̲Y̲,̲Z̲,̲a̲,̲b̲,̲c̲,̲d̲,̲e̲,̲f̲,̲g̲,̲h̲,̲i̲,̲j̲,̲k̲,̲l̲,̲m̲,̲n̲,̲o̲,̲p̲,̲q̲,̲r̲,̲s̲,̲t̲,̲u̲,̲v̲,̲w̲,̲x̲,̲y̲,̲z̲,̲0̲,̲9̲,̲8̲,̲7̲,̲6̲,̲5̲,̲4̲,̲3̲,̲2̲,̲1̲,̲.̲,̲_̲",
				"Â,ß,Ĉ,Ð,Є,Ŧ,Ǥ,Ħ,Ī,ʖ,Қ,Ŀ,♏,И,Ø,P,Ҩ,R,$,ƚ,Ц,V,Щ,X,￥,Ẕ,Â,ß,Ĉ,Ð,Є,Ŧ,Ǥ,Ħ,Ī,ʖ,Қ,Ŀ,♏,И,Ø,P,Ҩ,R,$,ƚ,Ц,V,Щ,X,￥,Ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
				}
					 result = {}
					i=0
					for k=1,#fonts_en do
					i=i+1
					 tar_font = fonts_en[i]:split(",")
					 text = WORD
					 text = text:gsub("A",tar_font[1])
					 text = text:gsub("B",tar_font[2])
					 text = text:gsub("C",tar_font[3])
					 text = text:gsub("D",tar_font[4])
					 text = text:gsub("E",tar_font[5])
					 text = text:gsub("F",tar_font[6])
					 text = text:gsub("G",tar_font[7])
					 text = text:gsub("H",tar_font[8])
					 text = text:gsub("I",tar_font[9])
					 text = text:gsub("J",tar_font[10])
					 text = text:gsub("K",tar_font[11])
					 text = text:gsub("L",tar_font[12])
					 text = text:gsub("M",tar_font[13])
					 text = text:gsub("N",tar_font[14])
					 text = text:gsub("O",tar_font[15])
					 text = text:gsub("P",tar_font[16])
					 text = text:gsub("Q",tar_font[17])
					 text = text:gsub("R",tar_font[18])
					 text = text:gsub("S",tar_font[19])
					 text = text:gsub("T",tar_font[20])
					 text = text:gsub("U",tar_font[21])
					 text = text:gsub("V",tar_font[22])
					 text = text:gsub("W",tar_font[23])
					 text = text:gsub("X",tar_font[24])
					 text = text:gsub("Y",tar_font[25])
					 text = text:gsub("Z",tar_font[26])
					 text = text:gsub("a",tar_font[27])
					 text = text:gsub("b",tar_font[28])
					 text = text:gsub("c",tar_font[29])
					 text = text:gsub("d",tar_font[30])
					 text = text:gsub("e",tar_font[31])
					 text = text:gsub("f",tar_font[32])
					 text = text:gsub("g",tar_font[33])
					 text = text:gsub("h",tar_font[34])
					 text = text:gsub("i",tar_font[35])
					 text = text:gsub("j",tar_font[36])
					 text = text:gsub("k",tar_font[37])
					 text = text:gsub("l",tar_font[38])
					 text = text:gsub("m",tar_font[39])
					 text = text:gsub("n",tar_font[40])
					 text = text:gsub("o",tar_font[41])
					 text = text:gsub("p",tar_font[42])
					 text = text:gsub("q",tar_font[43])
					 text = text:gsub("r",tar_font[44])
					 text = text:gsub("s",tar_font[45])
					 text = text:gsub("t",tar_font[46])
					 text = text:gsub("u",tar_font[47])
					 text = text:gsub("v",tar_font[48])
					 text = text:gsub("w",tar_font[49])
					 text = text:gsub("x",tar_font[50])
					 text = text:gsub("y",tar_font[51])
					 text = text:gsub("z",tar_font[52])
					 text = text:gsub("0",tar_font[53])
					 text = text:gsub("9",tar_font[54])
					 text = text:gsub("8",tar_font[55])
					 text = text:gsub("7",tar_font[56])
					 text = text:gsub("6",tar_font[57])
					 text = text:gsub("5",tar_font[58])
					 text = text:gsub("4",tar_font[59])
					 text = text:gsub("3",tar_font[60])
					 text = text:gsub("2",tar_font[61])
					 text = text:gsub("1",tar_font[62])
					table.insert(result, text)
					end
				 result_text = "کلمه ی اولیه: "..WORD.."\nکلمه طراحی شده :\n"
					a=0
					for v=1,#result do
					a=a+1
					result_text = result_text..a.."- `"..result[a].."`\n\n"
					end
					tdbot.editMessageText(msg.chat_id, msg.id, nil, result_text, 1, false, nil, 'md')
				elseif WORD:match("[\216-\219][\128-\191]") then
				if #WORD < 2 then
					tdbot.editMessageText(msg.chat_id, msg.id, nil, 'بعد از این دستور، با قید یک فاصله کلمه یا جمله ی مورد نظر را جهت زیبا نویسی وارد کنید', 1, false, nil, 'md')
					end
					if string.len(WORD) > 20 then
					tdbot.editMessageText(msg.chat_id, msg.id, nil, 'حداکثر حروف مجاز 20 کاراکتر  و عدد است', 1, false, nil, 'md')
					end
					 font_base = "ض,ص,ق,ف,غ,ع,ه,خ,ح,ج,ش,س,ی,ب,ل,ا,ن,ت,م,چ,ظ,ط,ز,ر,د,پ,و,ک,گ,ث,ژ,ذ,آ,ئ,.,_"
				 font_hash = "ض,ص,ق,ف,غ,ع,ه,خ,ح,ج,ش,س,ی,ب,ل,ا,ن,ت,م,چ,ظ,ط,ز,ر,د,پ,و,ک,گ,ث,ژ,ذ,آ,ئ,.,_"
				fonts_fa = {
									"ۘۘضــ, ۘۘصـ, ۘۘقـ, ۘۘفـ, ۘۘغـ, ۘۘعـ, ۘۘهـ, ۘۘخـ, ۘۘحـ, ۘۘجـ, ۘۘشـ,ۘۘسـ, ۘۘیـ, ۘۘبـ, ۘۘلـ, ۘۘا, ۘۘنـ, ۘۘتـ, ۘۘمـ, ۘۘچـ, ۘۘظـ, ۘۘطـ,ۘۘز, ۘۘر, ۘۘد, ۘۘپـ, ۘۘو, ۘۘڪـ, ۘۘگـ, ۘۘثـ, ۘۘژ, ۘۘذ, ۘۘآ, ۘۘئـ,.___",
									"ضَِـٖٖـۘۘـُِ,صَِـُّ℘ـʘ͜͡,قـٖٖـۘۘـ,فـٖٖـۘۘـُِ,غَِـُّ℘ـʘ͜͡,عـٖٖـۘۘـ,هَِـٖٖـۘۘـُِ,خَِـَّ℘ـʘ͜͡,حـٖٖـۘۘـ,جـٖٖـۘۘـُِ,شَِـُّ℘ـʘ͜͡,سَـٖٖـۘۘـ,یـٖٖـۘۘـُِ,بَـَّ℘ـʘ͜͡,لـٖٖـۘۘـ,اۘۘ,نِّـُّ℘ـʘ͜͡,تَـٖٖـۘۘـ,مُِـٖٖـۘۘـُِ,چٍّـََ℘ـʘ͜͡,ظُّـٖٖـۘۘـ,طِّـٖٖـۘۘـُِ,‌زُِ,رُِ,دَّ,پـٖٖـۘۘـ,وّ,کُّـٖٖـۘۘـُِ,گـ℘ـʘ͜͡,ثَـٖٖـۘۘـ,ژ,ذُّ,℘آ,ئـٖٖـۘۘـ,.,_",
									"ضــ,صــ,قــ,فــ,غــ,عــ,هــ,خــ,حــ,جــ,شــ,ســ,یـــ,بـــ,لــ,ا',نـــ,تـــ,مـــ,چــ,ظــ,طــ,زّ,رّ,دّ,پــ,,وّ,کــ,گــ,ثــ,ژّ,ذّ,آ,ئــ,.,_",
									"ضـَِـٖٖـ,صۘۘـُِـ℘ـʘ͜͡,قٖٖ ,فۘۘـُِـٖٖـۘۘـُِـ,غِِ  ,عِّـِّـۘۘـُِـ,هََ,❢خــًٍـْْـ,حْْـــْْـ,جًٍــْْـ❢,شََـََـََـََـََ,سََـََـََـََـََ,یََ,بََـــْْــََ❅,لََــََـََــ,ا',ݩ,تـެـެِэٖٖ‍ٖٖ‍ٖٖ‍ٖٖ‍ٖٖـ,مٖٖــٍ͜ـۘۘــ,چۘۘـِ؁,ظٖٖــۘۘـ,طۘۘـُِـۘۘ,ز',়ر',دۘۘـ, پـِّ؁,وَِ,ڪـًّ,ِ؁,گٖٖــٍ͜ـۘۘــ,ثۘۘـِ؁,'ژ',ذ'ً,ًّ,়়آ,়়ئّّ'',.,_",
									"ض̈́ـ̈́ـ̈́ـ̈́ـ,ص̈́ـ̈́ـ̈́ـ̈́ـ,قـ̈́ـ̈́ـ̈́ـ,فـ̈́ـ̈́ـ̈́ـ̈́ـ,غ̈́ـ̈́ـ̈́ـ̈́ـ,ع̈́ـ̈́ـ̈́ـ̈́ـ,ه̈́ـ̈́ـ̈́ـ̈́ـ,خـ̈́ـ̈́ـ̈́ـ,ح̈́ـ̈́ـ̈́ـ̈́ـ,ج̈́ـ̈́ـ̈́ـ̈́ـ,شـ̈́ـ̈́ـ̈́ـ,سـ̈́ـ̈́ـ̈́ـ,ی̈́ـ̈́ـ̈́ـ̈́ـ,ب̈́ـ̈́ـ̈́ـ̈́ـ,ل̈́ـ̈́ـ̈́ـ̈́ـ,̈́ا,ن̈́ـ̈́ـ̈́ـ̈́ـ,ت̈́ـ̈́ـ̈́ـ̈́ـ,م̈́ـ̈́ـ̈́ـ̈́ـ,چـ̈́ـ̈́ـ̈́ـ,ظـ̈́ـ̈́ـ̈́ـ̈́ـ,ط̈́ـ̈́ـ̈́ـ̈́ـ,ز',ر',د',پ̈́ـ̈́ـ̈́ـ̈́ـ,̈́̈́و,کـ̈́ـ̈́ـ̈́ـ,گـ̈́ـ̈́ـ̈́ـ̈́ـ,ث̈́ـ̈́ـ̈́ـ̈́ـ,̈́ژ',ذ',آ',ئ̈́ـ̈́ـ̈́ـ,.,__",
									"ضـٜٜـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜـٜ٘ـٍٍʘ͜͡ʘ͜͡ـٍٜ,ص۪۪ـؔٛـؒؔـ۪۪,ـقـ۪۪ـؒؔـ۪۪ـৃَـ,ـ؋ـ,غ,عـْْـْْـْْ✮ْْ,ه,ـפֿـ,ـפـ,جـٜ۪✶ًً◌,ش,ـωـ,ےٖٖ•,ب, لـؒؔـؒؔ℘,↭ٖٓا,نـ۪ٞ,تـ۪۪ـؒؔـ۪۪ـِْ,مـٰٰـٰٰ,چ,ظ,ط,ز✶ًً◌,ر√,ــدٍٕ,پـٜٜـٍٍـٜٜ℘͡ـٜٜ✮,ـפּـ,ڪ,❆گـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,ث,ژ^°√,ذ,آ,ئ,.,___",
									"ِ↲ضـூ͜͡,صـۡۙـُُـ़,قـ്͜ــ,◌فــ͜͡ـ☆͜͡➬,غـٖٖـ,✞ٜ۪ـٜ۪ع,ـެِэٖٖ‍ٖٖ‍ٖٖ‍ٖٖ‍ٖٖهٖٖ,خـံີـؒؔ,حــٌ۝ؔؑـެِэٖٖ‍ٖٖ‍ٖ,جـَ͜❁,ــ͜͡ـشـ☆͜͡,سـٖٖـــ,يٰٰـٰٰـٰٰـ, ٰٰبـًٍ,لٜ۪ـٜ۪,ံີا,ެِэٖٖ‍ٖٖ‍ٖٖ‍ٖٖ‍ٖٖـݩ,تـََـََـََـ,مـؒؔ◌͜͡ࢪ,ـچـٌ۝ؔؑ,ظًّـެِэٖٖ‍ٖٖ‍ٖٖ‍ٖٖ‍ٖٖ,طٌِـٌ۝ؔؑ,ٖٖزံີ,ࢪ,ـَ͜د,پـٜٜـٜٓـٜٜـٜٓـٜٜـٜٜـٜٜـ,ۋ℘,ڪـٰٖـٰٰـٜٜـٜٓـٜٓـٜٓـٜٜ,گـٖٖـٖٖ,ثـؒؔ◌,ٌ۝ؔؑژِэٖٖ‍ٖٖ‍ٖٖ,ـْٜـذ,❀آ,ئٰٰـٰٰـًٍ,.,__",
									"ضـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,صـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,قـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,فـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,غٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ, ٍٍ‍ٍٍعٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,ٍٍ‍ٍٍهٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,خـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,حـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,جـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,شـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,سـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ, ًًیَِـََـََـََـَِ, بـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ, ًًلٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,ا', ًنََـٍٍـٜٜـٜۘـٜٓـٍٜ,تـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,مـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,چـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,ظـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,طـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,''ز,ر',  ًًد'', پـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,وٍٍ‍ٍ‍‍‍ ,ڪـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,گـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,ثـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,ًژ,ََذ,❢آ''',ئـٜٜـٍٍـٜٜـٜۘـٜٓـ,.,__",
									"ضـ﹏ـ,صـ﹏ــ,قـ﹏ـ,فـ﹏ـ,غـ﹏ـ,عـ﹏ـ,هـ﹏ـ,خـ﹏ـ,حـ﹏ـ,جـ﹏ــ,شـ﹏ـ,سـ﹏ـ,یـ﹏ـ,بـ﹏ـ,لـ﹏ــ,ا',نـ﹏ـ,تـ﹏ـ,مـ﹏ـ,چـ﹏ـ,ظـ﹏ــ,طـ﹏ـ,ز,ر,د,پـ﹏ـ,و,کـ﹏ـ,گـ﹏ـ,ثـ﹏ــ,ژ,ذ,آ,ئـ﹏ــ,.,_",
									"ضـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,صـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,قـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,فـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,غـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,عـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,هـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,خـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,حـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,جـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,شـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,سـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,یـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,بـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,لـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,ا',نـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,تـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,مـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,چـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,ظـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,طـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,ز۪ٜ‌,ر۪ٜ,د۪ٜ,پـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,و',کـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,گـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,ثـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,ژ۪ٜ,ذ۪ٜ,آ,ئـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,.,_",
									"়়ضًَـ়ৃ,صَৃـ,়ۘـقٍٰـۘۘ,فََـۘۘ✾ُُ:,◌͜͡غ, عَؔـٍٍʘ͜͡ʘ,هـَ͜❁ٜ۪,خـِِ✿ٰٰ‌,حـٖٖ℘ـ,جـؒؔـؔؔـٖٖـؔـ,شـٜٜـٜٓـٜٜـٜٓـٜٜـٜٜـٜٜـ,سـٰٖـٰٰـٜٜـٜٓـٜٓـٜٓـٜٜـ,ـےٍٕ,بـــ✄ــ,ل҉ ـ,ٰံاًّ,۪۪نـ↭ٰٰـ۪۪,تـَ͜❁ٜ۪ـ,مــؒؔ✫ؒؔـ ҉๏̯̃๏ًٍ,چۘۘـ ۪۪ـٰٰـ,ظـؒؔـؔؔـٖٖـؔـ ــ,طُّـۘۘ↭,✵͜͡ز,رؒؔ◌͜͡◌,َؔد,پّـꯩ้ี,ٰۘوٰٖ,کـ͜͝ـ͜͝ـ,گـ͜͝ـ͜͝ـ,ث͜͝ـ❁۠۠ـ͜͝ـ۪ٜـ۪ٜ❀͜͡ـ,ژؒؔ❁,ـٜٜـٜٓـٜٜـٜٓـٜٜـٜٜـٜٜذ,✺آٍጀ,ٍጀئ,.__",
									"ض✿ٰٰ‌✰ض۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,صـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,قـٍٍ℘͡ـٜٜ,فـَ͜ـ,غـَ͜✾ٖٖ,عुؔـ,℘͡ـهٜुـ,خـَ͜✾ٖٖ,ح͡ـٜٜ,ـجٍٍ℘,شـٖٖ,سـۘۘـُِ℘ـʘ͜,یـٖٖـۘۘـٖٖ,✺ًّ‏َؔب,,لۣۗـًٍـٍَـ,ٍٓ‍ؒؔا,ـنـؔؔ‌ؒؔ,ؒؔ✺تًّ‏َؔ«ۣۗ,مـٍَـٍٓ‍ؒؔـ۪۪ـؔؔ‌ؒؔـؒؔـؒؔـؒؔ,چـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,ظ۪ٜ,ـ۪ٜط۪ٜـ۪ٜـ۪ٜ,ز۪ٜ,ر௸,ـدؒؔ,پِـَِـَِـَِـَِـَِـَِـَِـَ,◌͜͡و◌,ڪـَ͜✾ٖٖ,گٍٖـْْ❥ٍٍـٍٍ,ثْْـٍٍ,ژُُ,ـَ͜ذ,﷽آ,ئ҉ــ҉ۘۘ,ٓٓ,,ـَ͜,,.,__",
									"ضـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,صـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,قـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,فـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,غٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ, ٍٍ‍ٍٍعٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,ٍٍ‍ٍٍهٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,خـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,حـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,جـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,شـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,سـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ, ًًیَِـََـََـََـَِ, بـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ, ًًلٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,ا', ًنََـٍٍـٜٜـٜۘـٜٓـٍٜ,تـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,مـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,چـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,ظـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,طـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,''ز,ر',  ًًد'', پـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,وٍٍ‍ٍ‍‍‍ ,ڪـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,گـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,ثـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,ًژ,ََذ,❢آ''',ئـٜٜـٍٍـٜٜـٜۘـٜٓـ,.,__",
									"ضٖٖـۘۘ℘ـʘ͜͡,صـٖٖـۘۘ℘ـʘ͜͡,قـٖٖـۘۘ℘ـʘ͜͡,فـٖٖـۘۘ℘ـʘ͜͡,غـٖٖـۘۘ℘ـʘ͜͡,عـٖٖـۘۘ℘ـʘ͜͡,هـٖٖـۘۘ℘ـʘ͜͡,خـٖٖـۘۘ℘ـʘ͜͡,حـٖٖـۘۘ℘ـʘ͜͡,جـٖٖـۘۘ℘ـʘ͜͡,شـٖٖـۘۘ℘ـʘ͜͡,سـٖٖـۘۘ℘ـʘ͜͡,یـٖٖـۘۘ℘ـʘ͜͡,بـٖٖـۘۘ℘ـʘ͜͡,لـٖٖـۘۘ℘ـʘ͜͡,ا',نـٖٖـۘۘ℘ـʘ͜͡,تـٖٖـۘۘ℘ـʘ͜͡,مـٖٖـۘۘ℘ـʘ͜͡,چـٖٖـۘۘ℘ـʘ͜͡,ظـٖٖـۘۘ℘ـʘ͜͡,طـٖٖـۘۘ℘ـʘ͜͡,ز,ر,د,پـٖٖـۘۘ℘ـʘ͜͡,و,ڪـٖٖـۘۘ℘ـʘ͜͡,گـٖٖـۘۘ℘ـʘ͜͡,ۘثـٖٖـۘۘ℘ـʘ͜͡,ژ,ذ,آ,ئـٖٖـۘۘ℘ـʘ͜͡,.,_",
									"ضـ෴ِْ,صـ෴ِْ,قـ෴ِْ,فـ෴ِْ,غـ෴ِْ,عـ෴ِْ,هـ෴ِْ,خـ෴ِْ,حـ෴ِْ,جـ෴ِْ,شـ෴ِْ,سـ෴ِْ,یـ෴ِْ,بـ෴ِْ,لـ෴ِْ,ا',نـ෴ِْ,تـ෴ِْ,مـ෴ِْ,چـ෴ِْ,ظـ෴ِْ,طـ෴ِْ,ز,ر,د,پـ෴ِْ,و,کـ෴ِْ,گـ෴ِْ,ثـ෴ِْ,ژ,ذ,آ',ئـ෴ِْ,.,__",
									"ضـًٍʘًٍʘـ,صـًٍʘًٍʘـ,قـًٍʘًٍʘـ,فـًٍʘًٍʘـ,غـًٍʘًٍʘـ,عـًٍʘًٍʘـ,هـًٍʘًٍʘـ,خـًٍʘًٍʘـ,حـًٍʘًٍʘـ,جـًٍʘًٍʘـ,شـًٍʘًٍʘـ,سـًٍʘًٍʘـ,یـًٍʘًٍʘـ,بـًٍʘًٍʘـ,لـًٍʘًٍʘـ,أ,نـًٍʘًٍʘـ,تـًٍʘًٍʘـ,مـًٍʘًٍʘـ,چـًٍʘًٍʘـ,ظـًٍʘًٍʘـ,طـًٍʘًٍʘـ,زََ,رََ,دََ,پـًٍʘًٍʘـ,ٌۉ,,کـًٍʘًٍʘـ,گـًٍʘًٍʘـ,ثـًٍʘًٍʘـ,ژَِ,ذِِ,آ,ئـًٍʘًٍʘـ,.,__",
									"ضـؒؔـؒؔـَؔ௸,صـؒؔـؒؔـَؔ௸,قـؒؔـؒؔـَؔ௸,فـؒؔـؒؔـَؔ௸,غـؒؔـؒؔـَؔ௸,عـؒؔـؒؔـَؔ௸,ھـؒؔـؒؔـَؔ௸,خـؒؔـؒؔـَؔ௸,حـؒؔـؒؔـَؔ௸,جـؒؔـؒؔـَؔ௸,شـؒؔـؒؔـَؔ௸,سـؒؔـؒؔـَؔ௸,یـؒؔـؒؔـَؔ௸,بـؒؔـؒؔـَؔ௸,لـؒؔـؒؔـَؔ௸,ا,نـؒؔـؒؔـَؔ௸,تـؒؔـؒؔـَؔ௸,مـؒؔـؒؔـَؔ௸,چـؒؔـؒؔـَؔ௸,ظـؒؔـؒؔـَؔ௸,طـؒؔـؒؔـَؔ௸,ز,ر,د,پـؒؔـؒؔـَؔ௸,و,کـؒؔـؒؔـَؔ௸,گـؒؔـؒؔـَؔ௸,ثـؒؔـؒؔـَؔ௸,ژ,آ,ئـؒؔـؒؔـَؔ௸,.,_",
									"ضٜٜــؕؕـٜٜـٜٜ✿,صٜٜــؕؕـٜٜـٜٜ✿,قٜٜــؕؕـٜٜـٜٜ✿,فٜٜــؕؕـٜٜـٜٜ✿,غــؕؕـٜٜـٜٜ✿,عٜٜــؕؕـٜٜـٜٜ✿,هٜٜــؕؕـٜٜـٜٜ✿,خــؕؕـٜٜـٜٜ✿,حٜٜــؕؕـٜٜـٜٜ✿,جــؕؕـٜٜـٜٜ✿,شٜٜــؕؕـٜٜـٜٜ✿,سٜٜــؕؕـٜٜـٜٜ✿,یٜٜــؕؕـٜٜـٜٜ✿,بــؕؕـٜٜـٜٜ✿,لــؕؕـٜٜـٜٜ✿,ٜٜا,نٜٜــؕؕـٜٜـٜٜ✿,تٜٜــؕؕـٜٜـٜٜ✿,مــؕؕـٜٜـٜٜ✿,چٜٜــؕؕـٜٜـٜٜ✿,ظٜٜــؕؕـٜٜـٜٜ✿,طــؕؕـٜٜـٜٜ✿,ٜٜزٜٜ✿,ٜٜرؕ✿,دٜٜ,پـٜٜــؕؕـٜٜـٜٜ✿,وٜٜ,کٜٜــؕؕـٜٜـٜٜ✿,گٜٜــؕؕـٜٜـٜٜ✿,ثٜٜــؕؕـٜٜـٜٜ✿,ژٜٜ✿,ذٜٜ,✿آ,ئٜٜــؕؕـٜٜـٜٜ✿,.,_",
									"ضَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َصَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,قـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,فَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َغَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,عَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,هَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َخَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,حَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,جَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َشَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,سَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,یَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َبَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,لَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,اَِ,نَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َتَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,مَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,چَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َظَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,طَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,زَِ,رَِ,دَِ,پَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َوًَ,کَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,گـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,ثَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َژَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,ذَِ,آ,ئـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,.,_",
									"ضـٰٖـۘۘـــٍٰـ,صـٰٖـۘۘـــٍٰـ,قـٰٖـۘۘـــٍٰـ,فـٰٖـۘۘـــٍٰـ,غـٰٖـۘۘـــٍٰـ,عـٰٖـۘۘـــٍٰـ,هـٰٖـۘۘـــٍٰـ,خـٰٖـۘۘـــٍٰـ,حـٰٖـۘۘـــٍٰـ,جـٰٖـۘۘـــٍٰـ,شـٰٖـۘۘـــٍٰـ,سـٰٖـۘۘـــٍٰـ,یـٰٖـۘۘـــٍٰـ,بـٰٖـۘۘـــٍٰـ,لـٰٖـۘۘـــٍٰـ,ا,نـٰٖـۘۘـــٍٰـ,تـٰٖـۘۘـــٍٰـ,مـٰٖـۘۘـــٍٰـ,چـٰٖـۘۘـــٍٰـ,ظـٰٖـۘۘـــٍٰـ,طـٰٖـۘۘـــٍٰـ,زٰٖ,رٰٖ,دٰٖ,پـٰٖـۘۘـــٍٰـ,و়়,لـٰٖـۘۘـــٍٰـ,گـٰٖـۘۘـــٍٰـ,ثـٰٖـۘۘـــٍٰ,ژٰٖ,ذۘۘ,آ়,ئـٰٖـۘۘـــٍٰـ,.,_",
									"ضـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,صـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,قـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,فـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,,غـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,عـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,هـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,خـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,حـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,جـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,شـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,سـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,یـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,بـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,لـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,ا͜͝,نـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,تـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,مـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,چـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,ظـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,طـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,͜͝ز❁۠۠,❁ر۠۠,❁د۠۠,پـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,❁۠۠و,کـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,گـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,ثـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,❁ژ۠۠,❁ذ۠۠,❁۠۠آ,ئـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,.,_",
									"ضـ͜͝ـ۪ٜـ۪ٜ❀,صـ͜͝ـ۪ٜـ۪ٜ❀,قـ͜͝ـ۪ٜـ۪ٜ❀,فـ͜͝ـ۪ٜـ۪ٜ❀,غـ͜͝ـ۪ٜـ۪ٜ,عـ͜͝ـ۪ٜـ۪ٜ❀,هـ͜͝ـ۪ٜـ۪ٜ❀,خـ͜͝ـ۪ٜـ۪ٜ❀,حـ͜͝ـ۪ٜـ۪ٜ❀,جـ͜͝ـ۪ٜـ۪ٜ,شـ͜͝ـ۪ٜـ۪ٜ❀,سـ͜͝ـ۪ٜـ۪ٜ❀,یـ͜͝ـ۪ٜـ۪ٜ❀,بـ͜͝ـ۪ٜـ۪ٜ❀,لـ͜͝ـ۪ٜـ۪ٜ❀,❀ا❀,نـ͜͝ـ۪ٜـ۪ٜ❀,تـ͜͝ـ۪ٜـ۪ٜ❀,مـ͜͝ـ۪ٜـ۪ٜ❀,چـ͜͝ـ۪ٜـ۪ٜ❀,ظـ͜͝ـ۪ٜـ۪ٜ❀,طـ͜͝ـ۪ٜـ۪ٜ❀,۪ٜز❀,۪ٜر❀,۪ٜ❀د,پـ͜͝ـ۪ٜـ۪ٜ❀,و❀,کـ͜͝ـ۪ٜـ۪ٜ❀,گـ͜͝ـ۪ٜـ۪ٜ❀,ثـ͜͝ـ۪ٜـ۪ٜ❀,ژ❀,ذ۪ٜ❀,͜͝ـ۪ٜ❀آ,ئـ͜͝ـ۪ٜـ۪ٜ❀,.,_",
									"ضـ℘ू,صـٰٰـۘۘ↭ٖٓ,قــٜ۪◌͜͡✾ـ,فــ℘ू,غـٜ۪◌͜͡✾,عـ℘ू,هـ℘ू,خـٰٰـۘۘ↭ٖٓ,حـٜ۪◌͜͡✾ـ,جـ℘ू,شـٰٰـۘۘ↭ٖٓ,سـٜ۪◌͜͡✾,یــ℘ू,بــ℘ू,لـٜ۪◌͜͡✾,ا℘ू,نـٰٰـۘۘ↭ٖٓ,تـٜ۪◌͜͡✾,مـ℘ू,چـ℘ू,ظـٰٰـۘۘ↭ٖٓ,طـٜ۪◌͜͡✾ـ,زُّ'℘ू,رٰٰ℘ू,ٜ۪◌د͜͡✾,پـ℘ू,ـٰٰوُّ,ڪـٜ۪◌͜͡✾,گـ℘ू,ثـٰٰـۘۘ↭ٖٓ,ژٜ۪◌͜͡✾,ذًَ℘ू,℘ूآ,ئـٰٰـۘۘ↭ٖٓ,.,_",
									"ضـ͜͝ـ۪ٜـ۪ٜ❀,صـ͜͝ـ۪ٜـ۪ٜ❀,قـ͜͝ـ۪ٜـ۪ٜ❀,فـ͜͝ـ۪ٜـ۪ٜ❀,غـ͜͝ـ۪ٜـ۪ٜ,عـ͜͝ـ۪ٜـ۪ٜ❀,هـ͜͝ـ۪ٜـ۪ٜ❀,خـ͜͝ـ۪ٜـ۪ٜ❀,حـ͜͝ـ۪ٜـ۪ٜ❀,جـ͜͝ـ۪ٜـ۪ٜ,شـ͜͝ـ۪ٜـ۪ٜ❀,سـ͜͝ـ۪ٜـ۪ٜ❀,یـ͜͝ـ۪ٜـ۪ٜ❀,بـ͜͝ـ۪ٜـ۪ٜ❀,لـ͜͝ـ۪ٜـ۪ٜ❀,❀ا❀,نـ͜͝ـ۪ٜـ۪ٜ❀,تـ͜͝ـ۪ٜـ۪ٜ❀,مـ͜͝ـ۪ٜـ۪ٜ❀,چـ͜͝ـ۪ٜـ۪ٜ❀,ظـ͜͝ـ۪ٜـ۪ٜ❀,طـ͜͝ـ۪ٜـ۪ٜ❀,۪ٜز❀,۪ٜر❀,۪ٜ❀د,پـ͜͝ـ۪ٜـ۪ٜ❀,و❀,کـ͜͝ـ۪ٜـ۪ٜ❀,گـ͜͝ـ۪ٜـ۪ٜ❀,ثـ͜͝ـ۪ٜـ۪ٜ❀,ژ❀,ذ۪ٜ❀,͜͝ـ۪ٜ❀آ,ئـ͜͝ـ۪ٜـ۪ٜ❀,.,_",
									"ضـ͜͡ــؒؔـ͜͝ـ,صـ͜͡ــؒؔـ͜͝ـ,قـ͜͡ــؒؔـ͜͝ـ,فـ͜͡ــؒؔـ͜͝ـ,غـ͜͡ــؒؔـ͜͝ـ,عـ͜͡ــؒؔـ͜͝ـ,هـ͜͡ــؒؔـ͜͝ـ,خـ͜͡ــؒؔـ͜͝ـ,حـ͜͡ــؒؔـ͜͝ـ,جـ͜͡ــؒؔـ͜͝ـ,شـ͜͡ــؒؔـ͜͝ـ,سـ͜͡ــؒؔـ͜͝ـ,یـ͜͡ــؒؔـ͜͝ـ,بـ͜͡ــؒؔـ͜͝ـ,لـ͜͡ــؒؔـ͜͝ـ,اؒؔ,نـ͜͡ــؒؔـ͜͝ـ,تـ͜͡ــؒؔـ͜͝ـ,مـ͜͡ــؒؔـ͜͝ـ,چـ͜͡ــؒؔـ͜͝ـ,ظـ͜͡ــؒؔـ͜͝ـ,طـ͜͡ــؒؔـ͜͝ـ,❁'ز'۠۠,ر҉   ,❁'د۠۠,پـ͜͡ــؒؔـ͜͝ـ,'وۘۘ',کـ͜͡ــؒؔـ͜͝ـ,گـ͜͡ــؒؔـ͜͝ـ,ثـ͜͡ــؒؔـ͜͝ـ,❁'ژ۠۠,❁'د'۠۠,❁۠۠,آ,ئـ͜͡ــؒؔـ͜͝ـ,.,_",
									"ضٰٖـٰٖ℘ـَ͜✾ـ,صٰٖـٰٖ℘ـَ͜✾ـ,قٰٖـٰٖ℘ـَ͜✾ـ,فٰٖـٰٖ℘ـَ͜✾ـ,غٰٖـٰٖ℘ـَ͜✾ـ,عٰٖـٰٖ℘ـَ͜✾ـ,هٰٖـٰٖ℘ـَ͜✾ـ,خٰٖـٰٖ℘ـَ͜✾ـ,حٰٖـٰٖ℘ـَ͜✾ـ,جٰٖـٰٖ℘ـَ͜✾ـ,شٰٖـٰٖ℘ـَ͜✾ـ,سٰٖـٰٖ℘ـَ͜✾ـ,یٰٖـٰٖ℘ـَ͜✾ـ,بٰٖـٰٖ℘ـَ͜✾ـ,لٰٖـٰٖ℘ـَ͜✾ـ,اٰٖـٰٖ℘ـَ͜✾ـ,نٰٖـٰٖ℘ـَ͜✾ـ,تٰٖـٰٖ℘ـَ͜✾ـ,مٰٖـٰٖ℘ـَ͜✾ـ,چٰٖـٰٖ℘ـَ͜✾ـ,ظٰٖـٰٖ℘ـَ͜✾ـ,طٰٖـٰٖ℘ـَ͜✾ـ,زٰٖـٰٖ℘ـَ͜✾ـ,رٰٖـٰٖ℘ـَ͜✾ـ,دٰٖـٰٖ℘ـَ͜✾ـ,پٰٖـٰٖ℘ـَ͜✾ـ,وٰٖـٰٖ℘ـَ͜✾ـ,کٰٖـٰٖ℘ـَ͜✾ـ,گٰٖـٰٖ℘ـَ͜✾ـ,ثٰٖـٰٖ℘ـَ͜✾ـ,ژٰٖـٰٖ℘ـَ͜✾ـ,ذٰٖـٰٖ℘ـَ͜✾ـ,آٰٖـٰٖ℘ـَ͜✾ـ,ئٰٖـٰٖ℘ـَ͜✾ـ,.ٰٖـٰٖ℘ـَ͜✾ـ,_",
									"ض❈ۣۣـ🍁ـ,ص❈ۣۣـ🍁ـ,ق❈ۣۣـ🍁ـ,ف❈ۣۣـ🍁ـ,غ❈ۣۣـ🍁ـ,ع❈ۣۣـ🍁ـ,ه❈ۣۣـ🍁ـ,خ❈ۣۣـ🍁ـ,ح❈ۣۣـ🍁ـ,ج❈ۣۣـ🍁ـ,ش❈ۣۣـ🍁ـ,س❈ۣۣـ🍁ـ,ی❈ۣۣـ🍁ـ,ب❈ۣۣـ🍁ـ,ل❈ۣۣـ🍁ـ,ا❈ۣۣـ🍁ـ,ن❈ۣۣـ🍁ـ,ت❈ۣۣـ🍁ـ,م❈ۣۣـ🍁ـ,چ❈ۣۣـ🍁ـ,ظ❈ۣۣـ🍁ـ,ط❈ۣۣـ🍁ـ,ز❈ۣۣـ🍁ـ,ر❈ۣۣـ🍁ـ,د❈ۣۣـ🍁ـ,پ❈ۣۣـ🍁ـ,و❈ۣۣـ🍁ـ,ک❈ۣۣـ🍁ـ,گ❈ۣۣـ🍁ـ,ث❈ۣۣـ🍁ـ,ژ❈ۣۣـ🍁ـ,ذ❈ۣۣـ🍁ـ,آ❈ۣۣـ🍁ـ,ئ❈ۣۣـ🍁ـ,.❈ۣۣـ🍁ـ,_",
									"ضـೄ,صـ۪۪ـؒؔـؒؔ◌͜͡◌,قـ۪۪ـؒؔـ۪۪,فـ͜͡ــؒؔـ͜͝ـ,غـೄ,عـ۪۪ـؒؔـ۪۪,هٍٖ❦,خـٜٓـٍٜـٜ٘ـ,حـٜ٘ـَٖ,جٍٍـٍٜــٍٍـٜ٘,͜͡∅شٍٜ۩,↜͜͡∅سٍٜ۩,یٜ٘,↭ِِبَٖ↜͜͡,لـٍٍـٍٜــٍٍـٜ٘∅,↜͜͡'اَُ'ِ,❦نٍٓ,تـــ۪۪ـؒؔــؒؔ◌͜͡◌,مـೄ,چــ۪۪ـؒؔـ۪۪,❀ظـؒؔ❀,طــَ͜✿ٰ,✧زٰٰ‌〆۪۪,✵ٍٓ ٍٖر,دٍٖ❦,پـٖٖـٖٖــَ͜✧,℘و'َ͜✿,کـٖٖـٖٖ‍℘,گـؒؔـٰٰ‌℘,❀ثـٜـؒؔ〆۪۪,ژٍٖ❦,✿ٰٰ‌ذ❀✵آٍٓ✵ٓ,ئـೄ,.,_",
									"✮ًٍضـًٍـَؔ✯ًٍ,✮صًٍـًٍـَؔ✯ًٍ,✮قًٍـًٍـَؔ✯ًٍ,✮ًٍفـًٍـَؔ✯ًٍ,✮غًٍـًٍـَؔ✯,ًٍ✮عًٍـًٍـَؔ✯ًٍ,✮هًٍـًٍـَؔ✯ًٍ,✮خًٍـًٍـَؔ✯ًٍ,✮ًٍحـٜـًٍـَؔ✯ًٍ,✮جًٍـًٍـَؔ✯ًٍ,✮شًٍـًٍـَؔ✯ًٍ,✮سًٍـًٍـَؔ✯ًٍ,✮ًٍیــًٍـَؔ✯ًٍ,✮بـًٍـًٍـَؔ✯ًٍ,✮لـًٍـًٍـَؔ✯ًٍ,✮ًٍا✯ًٍ,✮نًٍـًٍـَؔ✯ًٍ,✮تًٍـًٍـَؔ✯ًٍ,✮مًٍـًٍـَؔ✯ًٍ,✮چًٍـًٍـَؔ✯ًٍ,✮ظًٍـًٍـَؔ✯ًٍ,✮ًٍطـًٍـَؔ✯ًٍ,زَؔ✯ًٍ,ًٍرَؔ✯ًٍ,✮ًٍد,َؔ✮پًٍـًٍـَؔ✯ًٍ,✯ًٍو,✮ًٍکـًٍـَؔ✯ًٍ,✮ًٍگـًٍـَؔ✯ًٍ,✮ًٍثــًٍـَؔ✯ًٍ,✮ژًٍ,✯ًٍذ,✮آًٍ✯ًٍ,✮ئـًٍـًٍـَؔ✯ًٍ,.,_",
									"ضـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,صـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,قـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,فـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,غـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,عـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,هـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,خـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,حـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,جـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,شـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,سـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,یـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,بـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,لـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,✯اّّ✯,نـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,تـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,مـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,چـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,ظـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,طـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,✯زَّ'✯,✯ر✯,✯د✯,پـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,‌ົ້◌ฺฺ'‌ົ້و◌ฺฺ,ڪـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,گـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,ثـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,‌ົ້◌ฺฺژ,✯ذ✯,ಹ۪۪'آ'‌ົ້◌ฺฺಹ۪۪,ئـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,.,_",
									"ضـٰٖـۘۘـــٍٰـ,صـٰٖـۘۘـــٍٰـ,قـٰٖـۘۘـــٍٰـ,فـٰٖـۘۘـــٍٰـ,غـٰٖـۘۘـــٍٰـ,عـٰٖـۘۘـــٍٰـ,ه',خـٰٖـۘۘـــٍٰـ,حـٰٖـۘۘـــٍٰـ,جـٰٖـۘۘـــٍٰـ,شـٰٖـۘۘـــٍٰـ,سـٰٖـۘۘـــٍٰـ,یـٰٖـۘۘـــٍٰـ,بـٰٖـۘۘـــٍٰـ,لـٰٖـۘۘـــٍٰـ,ا,نـٰٖـۘۘـــٍٰـ,تـٰٖـۘۘـــٍٰـ,مـٰٖـۘۘـــٍٰـ,چـٰٖـۘۘـــٍٰـ,ظـٰٖـۘۘـــٍٰـ,طـٰٖـۘۘـــٍٰـ,ز,ر,د,پـٰٖـۘۘـــٍٰـ,و,ڪـٰٖـۘۘـــٍٰـ,گـٰٖـۘۘـــٍٰـ,ثـٰٖـۘۘـــٍٰـ,ژ,ذ,آ,ئـٰٖـۘۘـــٍٰـ,.,_",
									"ضٰٓـؒؔـ۪۪ঊ۝,صٰٓـؒؔـ۪۪ঊ۝,قٰٓـؒؔـ۪۪ঊ۝,قٰٓـؒؔـ۪۪ঊ۝,غٰٓـؒؔـ۪۪ঊ۝,عٰٓـؒؔـ۪۪ঊ۝,هٰٓـؒؔـ۪۪ঊ۝,خٰٓـؒؔـ۪۪ঊ۝,ٰحٰٓـؒؔـ۪۪ঊ۝ٰٓ,جٰٓـؒؔـ۪۪ঊ۝,شٰٓـؒؔـ۪۪ঊ۝,سٰٓـؒؔـ۪۪ঊ۝,یٰٓـؒؔـ۪۪ঊ۝,بٰٓـؒؔـ۪۪ঊ۝,لٰٓـؒؔـ۪۪ঊ۝,اٰ۪,نٰٓـؒؔـ۪۪ঊ۝,تٰٓـؒؔـ۪۪ঊ۝,مٰٓـؒؔـ۪۪ঊ۝,چٰٓـؒؔـ۪۪ঊ۝,ظٰٓـؒؔـ۪۪ঊ۝,طٰٓـؒؔـ۪۪ঊ۝ٰٓ,زؓঊ,رٰٓ,۪۪دؓ,پٰٓـؒؔـ۪۪ঊ۝,وٰٓ,۪۪کٰٓـؒؔـ۪۪ঊ۝,گٰٓـؒؔـ۪۪ঊ۝,ثٰٓـؒؔـ۪۪ঊ۝,ؒؔژؓঊ,ذ۪۪ঊ,آٰٓ۝,ئٰٓـؒؔـ۪۪ঊ۝,.,_",
									"ض۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ص۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ق۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ف۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,غ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ع۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ه۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,خ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ح۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ج۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ش۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,س۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ی۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ب۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ل۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ٗؔ✰͜͡ا℘ِِ,ن۪۟ــ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ت۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,م۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,چ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ظ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ط۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,✰͜͡ز℘ِِ,ٗؔ✰ر͜͡℘ِِ,✰͜͡د℘ِِ,پ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,۪ٜ✰و͜͡℘ِِ,ڪ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,گ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ث۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,✰͜͡ژ℘ِِ,ٗؔ✰ذ͜͡℘ِِ,✰͜͡آ'℘ِِ,ئ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,.,_",
									"ضـ۪۪ইٌ,صـ۪۪ইٌ,قـ۪۪ইٌ,فّــٍ͜ـ়়,غــٍ͜ـ়়,ع়ۘـٖٖــ,,ۘۘهُِـۘۘ,,خـ়ـۘۘـٍٰ,حـْ₰ْۜ,جـْ₰ْۜ,شـْ ـْ₰,سّـ ـٍ͜ـ়়,یْۜـْ✤ْ,بـ̴̬℘̴̬ـ̴̬مـ̴̬℘,لـ̴̬ـ̴̬مـ,ا,نـ̴̬℘̴̬ـ̴, تـ̴̬℘̴̬ـ̴̬م̴̬,℘مـ̴̬ـ̴̬مـ℘,چــَؔ۝,ظــَؔ۝,ط়ـۘۘـٍٰ℘,زٌّ,رٌّ,دٌّ,پــٍ͜ـ়়و,ڪ়ۘ,گـٖٖـۘۘـۘۘـُِـۘۘ,ثــَ͜✿ٰٰ‌ᬼ✵,ژ,ذ,آ,ئــٜ۪✦ــٜ۪✦,.,_",
									"ضؔؑـَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,صؔؑــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,قؔؑــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,❂ؔؑفــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,غؔؑــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,عـَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,هؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,خؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,حؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,جــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,شؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,سـَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,یؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,بؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,لؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,اสฺฺ,ؔؑنــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,ؔؑتــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,مؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,چؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,ظؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,طؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,❂زؔؑ ـَؔ ,رสฺฺŗ,❂ؔؑـَؔد۪๛ٖؔ,ؔؑپــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,❂وؔؑ ـَؔ,ڪؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,گؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,ثؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,สฺฺŗـذَؔ๛ٖؔ,❂آ,ئؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,.,_",
									"ضــ ོꯨ҉ــؒؔ҉:ـــ,صــ ོꯨ҉ــؒؔ҉:ــــ,قــ ོꯨ҉ــؒؔ҉:ــــ,فــ ོꯨ҉ــؒؔ҉:ــــ,غــ ོꯨ҉ــؒؔ҉:ــــ,عــ ོꯨ҉ــؒؔ҉:ــــ,هــ ོꯨ҉ــؒؔ҉:ــــ,خــ ོꯨ҉ــؒؔ҉:ــــ,حــ ོꯨ҉ــؒؔ҉:ــــ,ج۪ٜــ ོꯨ҉ــؒؔ҉:ــــ,شــ ོꯨ҉ــؒؔ҉:ــــ,ســ ོꯨ҉ــؒؔ҉:ــــ,یــ ོꯨ҉ــؒؔ҉:ــــ,بــ ོꯨ҉ــؒؔ҉:ــــ,لــ ོꯨ҉ــؒؔ҉:ــــ,اــ ོꯨ҉ــؒؔ҉:ــــ,نــ ོꯨ҉ــؒؔ҉:ــــ,تــ ོꯨ҉ــؒؔ҉:ــــ,مــ ོꯨ҉ــؒؔ҉:ــــ,چــ ོꯨ҉ــؒؔ҉:ــــ,ظــ ོꯨ҉ــؒؔ҉:ــــ,طــ ོꯨ҉ــؒؔ҉:ــــ,زــ ོꯨ҉ــؒؔ҉:ــــ,رــ ོꯨ҉ــؒؔ҉:ــــ,دــ ོꯨ҉ــؒؔ҉:ــــ,پــ ོꯨ҉ــؒؔ҉:ــــ,وــ ོꯨ҉ــؒؔ҉:ــــ,کــ ོꯨ҉ــؒؔ҉:ــــ,گــ ོꯨ҉ــؒؔ҉:ــــ,ثــ ོꯨ҉ــؒؔ҉:ــــ,ژــ ོꯨ҉ــؒؔ҉:ــــ,ذــ ོꯨ҉ــؒؔ҉:ــــ,آ,ئ,.,_",
									"ضؔؑـَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,صؔؑــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,قؔؑــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,❂ؔؑفــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,غؔؑــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,عـَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,هؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,خؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,حؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,جــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,شؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,سـَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,یؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,بؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,لؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,اสฺฺ,ؔؑنــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,ؔؑتــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,مؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,چؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,ظؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,طؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,❂زؔؑ ـَؔ ,رสฺฺŗ,❂ؔؑـَؔد۪๛ٖؔ,ؔؑپــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,❂وؔؑ ـَؔ,ڪؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,گؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,ثؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,สฺฺŗـذَؔ๛ٖؔ,❂آ,ئؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,.,_",
									"ضؔؑـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑصـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑقـَؔ ـؔؑـَؔ๛ٖؔ,فؔؑـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑغـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑعـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑه۪๛ٖؔ,ؔؑخـَؔ ـؔؑـَؔ๛ٖؔ,حؔؑـَؔ ـؔؑـَؔ๛ٖؔ,جؔؑـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑشـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑسـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑیـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑبـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑلـَؔ ـؔؑـَؔ๛ٖؔ,ا,ؔؑنـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑتـَؔ ـؔؑـَؔ๛ٖؔ,مؔؑـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑچـَؔ ـؔؑـَؔ๛ٖؔ,طؔؑـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑظـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑزَؔ,ر,د,پؔؑـَؔ ـؔؑـَؔ๛ٖؔ,و,کؔؑـَؔ ـؔؑـَؔ๛ٖؔ,گؔؑـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑثـَؔ ـؔؑـَؔ๛ٖؔ,ژ,ذ,آ,ؔؑئـَؔ ـؔؑـَؔ๛ٖؔ,.,_",
									"ضـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,صـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,قـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,فـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,غـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,عـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,ه➤,خـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,حـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,جـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,شـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,سـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,یـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,بـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,لـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,ا✺۠۠➤,نـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,تـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,مـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,چـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,ظـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,طـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,ز✺۠۠➤,ر✺۠۠➤,د✺۠۠➤,پـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,و✺۠۠➤,کـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,گـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,ث✺۠۠➤,ژ✺۠۠➤,ذ✺۠۠➤,آ✺۠۠➤,ئ✺۠۠➤,.,_",
									"ضـٍ͜ـ❉,صـٍ͜ــٍ͜❉,قـٍ͜ــٍ͜ــٍ͜❉,فـٍ͜ـ❉,غـٍ͜ــٍ͜ـ❉,عـٍ͜ــٍ͜ــٍ͜ـ❉,هـٍ͜ـ❉,خـٍ͜ــٍ͜❉,حـٍ͜ــٍ͜ــٍ͜❉,جـٍ͜ـ❉,شـٍ͜ــٍ͜❉,سـٍ͜ــٍ͜ــٍ͜❉,یـٍ͜ـ❉,بـٍ͜ــٍ͜❉,لـٍ͜ــٍ͜❉,ـٍ͜ــٍ͜ــٍ͜ا❉,نـٍ͜ـ❉,تـٍ͜ــٍ͜❉,مـٍ͜ــٍ͜ــٍ͜❉,چـٍ͜ـ❉,ظـٍ͜ــٍ͜❉,طـٍ͜ــٍ͜❉,زٍ͜❉,رٍ͜❉,دٍ͜❉,پـٍ͜ـ❉,وۘ❉,ڪـٍ͜ــٍ͜ــٍ͜❉,گـٍ͜ـ❉,ثـٍ͜ــٍ͜❉,ژً❉,ذٌ❉,آ❉,ئـٍ͜ـ❉,.,_",
									"ضـْْـْْـْْ/ْْ,صـْْـْْـ,قْْـْْـْْـْْ/ْْ,فـْْـْْـ,ْْغـْْـْْـْْ/,عْْـْْـْْـْْ,هـْْـْْـْْ/,خْْـْْـْْـ,حْْـْْـْْـْْ/ْْ,جـْْـْْـْْ,شـْْـْْـْْ/ْْ,سـْْـْْـْْ,یـْْـْْـْْ/,بْْـْْـْْـ,لْْـْْـْْـْْ/ْْ,ـْْـْْـْْا,نـْْـْْـْْ/ْْ,تـْْـْْـْْ,مـْْـْْـْْ/ْْ,چْـْْـْْـ,ظْْـْْـْْـْْ/,طْْـْْـْْـْْ,زٌ/,ـْْر,ـْْـْْـدْْ/,پْْـْْـْْـ,ـْْـْْـْْو/ْْ,ڪْـْْـْْـْْ,گـْْـْْـْْ/,ثْْـْْـْْـْْ,ـْْـْْـژْْ/,ْْـْْـْْـذ,آْْ/ْْ,ئـْْـْْـْْـْْـْْ/ْْ,.,_",
									"↜ضٍٍـُِ➲ِِனُِ,صـِْـَِ➲َِனِِ,↜ٍٍقـُِ➲ِِனُِ,فـِْـَِ➲َِனِِ↝,↜ٍٍغـُِ➲ِِனُِ,عـِْـَِ➲َِனِِ↝,↜ٍٍهـُِ➲ِِனُِ,خـِْـَِ➲َِனِِ↝,↜ٍٍحـُِ➲ِِனُِ,جـِْـَِ➲َِனِِ↝,↜ٍٍشـُِ➲ِِனُِ,سـِْـَِ➲َِனِِ↝,↜یٍٍـُِ➲ِِனُِ,بـِْـَِ➲َِனِِ↝,↜ٍٍلـُِ➲ِِனُِ,ِْاَِ➲َِனِِ↝,↜نٍٍـُِ➲ِِனُِ,تـِْـَِ➲َِனِِ↝,↜مٍٍـُِ➲ِِனُِ,چـِْـَِ➲َِனِِ↝,↜ظٍٍـُِ➲ِِனُِ,طـِْـَِ➲َِனِِ↝,↜ٍٍـزُِ➲ِِனُِ,ـِْـَِرِ➲َِனِِ↝,↜ٍٍـُِد➲ِِனُِ,پـِْـَِ➲َِனِِ↝,↜ٍٍـُِو➲ِِனُِ,ـِْـَِ➲َِனِِ↝,↜ٍٍڪـُِ➲ِِனُِ,گـِْـَِ➲َِனِِ↝,↜ثٍٍـُِ➲ِِனُِ,ـِْـژَِ➲َِனِِ↝,↜ٍٍـُِذ➲ِِனُِ,آَِ➲َِனِِ↝,↜ٍٍئـُِ➲ِِனُِ↝,.,_",
									"ضـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,صـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,قـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,فـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,غـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,عـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,هـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,خـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,حـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,جـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,شـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,سـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,یـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,بـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,لـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,ا✓,ن̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,تـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,مـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,چـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,ظـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,طـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,̺ز◕̟͠₰̵͕◚̶̶₰͕͔,̚͠رـ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,د̵͠◕̟͠₰ ,پـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,ـ̚͠ــ̵͠و̺◕̟͠₰̵͕◚̶̶₰͕͔,ڪـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,گـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,ثـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,ژ◕̟͠₰̵͕◚̶̶₰͕͔,ـ̚͠ـذـ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,آ✓,ئـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,.,_",
									"ضـٰٓـًً◑ِّ◑ًً, صـུـٜٜ◑ِّ◑ًً,قـٰٓـًً◑ِّ◑ًً, فـུـٜٜ◑ِّ◑ًً,غـٰٓـًً◑ِّ◑ًً, عـུـٜٜ◑ِّ◑ًً,هـٰٓـًً◑ِّ◑ًً, خـུـٜٜ◑ِّ◑ًً,حـٰٓـًً◑ِّ◑ًً, جـུـٜٜ◑ِّ◑ًً,شـٰٓـًً◑ِّ◑ًً, سـུـٜٜ◑ِّ◑ًً,یـٰٓـًً◑ِّ◑ًً, بـུـٜٜ◑ِّ◑ًً,لـٰٓـًً◑ِّ◑ًً, ا◑ِّ◑ًً,نـٰٓـًً◑ِّ◑ًً, تـུـٜٜ◑ِّ◑ًً,مـٰٓـًً◑ِّ◑ًً, چـུـٜٜ◑ِّ◑ًً,ظـٰٓـًً◑ِّ◑ًً, طـུـٜٜ◑ِّ◑ًً,ز◑ِّ◑ًً,رٜٜ◑ِّ◑ًً,د◑ِّ◑ًً, پـུـٜٜ◑ِّ◑ًً,وًً◑ِّ◑ًً, ڪـུـٜٜ◑ِّ◑ًً,گـٰٓـًً◑ِّ◑ًً, ثـུـٜٜ◑ِّ◑ًً,ژ◑ِّ◑ًً,ذٜٜ◑ِّ◑ًً,ا◑ِّ◑ًً, ئـུـٜٜ◑ِّ◑ًً,.,_",
									"ضـ͜͡ـ͜͡✭,صـ͜͡ـ͜͡✭,قـ͜͡ـ͜͡ـ͜͡✭,فــ͜͡ـ͜͡✭,غـ͜͡ـ͜͡✭,عـ͜͡ـ͜͡✭,هـ͜͡ـ͜͡ـ͜͡✭,خــ͜͡ـ͜͡✭,حـ͜͡ـ͜͡✭,جـ͜͡ـ͜͡✭,شـ͜͡ـ͜͡ـ͜͡✭,ســ͜͡ـ͜͡✭,یـ͜͡ـ͜͡✭,بـ͜͡ـ͜͡✭,لـ͜͡ـ͜͡ـ͜͡✭,͜͡ا✭,نـ͜͡ـ͜͡✭,تـ͜͡ـ͜͡✭,مـ͜͡ـ͜͡ـ͜͡✭,چــ͜͡ـ͜͡✭,ظـ͜͡ـ͜͡✭,طـ͜͡ـ͜͡✭,ز͜͡✭,͜͡ر✭,͜͡د✭,پـ͜͡ـ͜͡✭,ـ͜͡و͜͡ـ͜͡✭,ڪــ͜͡ـ͜͡✭,گـ͜͡ـ͜͡✭,ـ͜͡ـ͜͡✭,ثـ͜͡ـ͜͡ـ͜͡✭,ـ͜͡ژ͜͡✭,ذ✭,آ✭,ئـ͜͡ـ͜͡ـ͜͡✭,.,_",
									"ضـًٍـؒؔـؒؔ⸙ؒৡ✪,صـًٍـؒؔـؒؔ⸙ؒৡ✪,قـًٍـؒؔـؒؔ⸙ؒৡ✪,فـًٍـؒؔـؒؔ⸙ؒৡ✪,غـًٍـؒؔـؒؔ⸙ؒৡ✪,عـًٍـؒؔـؒؔ⸙ؒৡ✪,هـًٍـؒؔـؒؔ⸙ؒৡ✪,خـًٍـؒؔـؒؔ⸙ؒৡ✪,حـًٍـؒؔـؒؔ⸙ؒৡ✪,جـًٍـؒؔـؒؔ⸙ؒৡ✪,شـًٍـؒؔـؒؔ⸙ؒৡ✪,سـًٍـؒؔـؒؔ⸙ؒৡ✪,یـًٍـؒؔـؒؔ⸙ؒৡ✪,بـًٍـؒؔـؒؔ⸙ؒৡ✪,لـًٍـؒؔـؒؔ⸙ؒৡ✪,ا✪,نـًٍـؒؔـؒؔ⸙ؒৡ✪,تـًٍـؒؔـؒؔ⸙ؒৡ✪,مـًٍـؒؔـؒؔ⸙ؒৡ✪,چـًٍـؒؔـؒؔ⸙ؒৡ✪,ظـًٍـؒؔـؒؔ⸙ؒৡ✪,طـًٍـؒؔـؒؔ⸙ؒৡ✪,ز✪,ر✪,د✪,پـًٍـؒؔـؒؔ⸙ؒৡ✪,و✪,ڪـًٍـؒؔـؒؔ⸙ؒৡ✪,گـًٍـؒؔـؒؔ⸙ؒৡ✪,ثـًٍـؒؔـؒؔ⸙ؒৡ✪,ژ✪,ذ✪,آ✪,ئـًٍـؒؔـؒؔ⸙ؒৡ✪,.,_",
									"ضـ◎۪۪❖ुؔ,صـ◎۪۪❖ुؔ,قـ◎۪۪❖ुؔ,فـ◎۪۪❖ुؔ,غـ◎۪۪❖ुؔ,عـ◎۪۪❖ुؔ,هـ◎۪۪❖ुؔ,خـ◎۪۪❖ुؔ,حـ◎۪۪❖ुؔ,جـ◎۪۪❖ु,شـ◎۪۪❖ु,سـ◎۪۪❖ु,یـ◎۪۪❖ु,بـ◎۪۪❖ु,لـ◎۪۪❖ु,ا◎۪۪❖ु,نـ◎۪۪❖ु,تـ◎۪۪❖ु,مـ◎۪۪❖ु,چـ◎۪۪❖ु,ظـ◎۪۪❖ु,طـ◎۪۪❖ु,ز◎۪۪❖ु,ر◎۪۪❖ु,د◎۪۪❖ु,پـ◎۪۪❖ु,و◎۪۪❖ु,ڪـ◎۪۪❖ु,گـ◎۪۪❖ु,ثـ◎۪۪❖ु,ژ◎۪۪❖ु,ذ◎۪۪❖ु,آ◎۪۪❖ु,ئـ◎۪۪❖ु,.,_",
									"ضِْـِْ❉,ِْصـِْ❉,قِْـِْ❉,ِْفـِْ❉,غِْـِْ❉,ِْعـِْ❉,ِْهـِْ❉,ِْخـِْ❉,ِْحـِْ❉,ِْجـِْ❉,ِْشـِْ❉,ِْسـِْ❉,یِْـِْ❉,بِْـِْ❉,لِْـِْ❉,ِْاـِْ❉,نِْـِْ❉,ِْتـِْ❉,ِْمـِْ❉,ِْچـِْ❉,ِْظـِْ❉,طِْـِْ❉,زِْـِْ❉,رِْـِْ❉,ِْدـِْ❉,پِْـِْ❉,وِْـِْ❉,ِْکـِْ❉,ِْگـِْ❉,ِْثـِْ❉,ِْژـِْ❉,ِْذـِْ❉,ِْآـِْ❉,ِْئـِْ❉,.,_",
									"[ِْـِْضـِْ❉ِْـِْ,[ِْـِْصـِْ❉ِْـِْ,[ِْـِْقـِْ❉ِْـِْ,[ِْـِْفـِْ❉ِْـِْ,[ِْـغِْـِْ❉ِْـِْ,[ِْـعِْـِْ❉ِْـِْ,[ِْـهِْـِْ❉ِْـِْ,[ِْـِْخـِْ❉ِْـِْ,[ِْـِْحـِْ❉ِْـِْ,[ِْـِْجـِْ❉ِْـِْ,[ِْـِْشـِْ❉ِْـِْ,[ِْـِْسـِْ❉ِْـِْ,[ِْـِْیـِْ❉ِْـِْ,[ِْـِْبـِْ❉ِْـِْ,[ِْـلِْـِْ❉ِْـِْ,[ِْـاِْـِْ❉ِْـِْ,[ِْـِْنـِْ❉ِْـِْ,[ِْـِْتـِْ❉ِْـِْ,[ِْـمِْـِْ❉ِْـِْ,[ِْـچِْـِْ❉ِْـِْ,[ِْـِْظـِْ❉ِْـِْ,[ِْـِْطـِْ❉ِْـِْ,[ِْـِْزـِْ❉ِْـِْ,[ِْـرِْـِْ❉ِْـِْ,[ِْـِْدـِْ❉ِْـِْ,[ِْـپِْـِْ❉ِْـِْ,[ِْـِْوـِِْْ❉ِْـِْ,[ِْـڪِْـِْ❉ِْـِْ,[ِْـگِْـِْ❉ِْـِْ,[ِْـِْثـِْ❉ِْـِْ,[ِْـِْژـِْ❉ِْـِْ,[ِْـذِْـِْ❉ِْـِْ,[ِْـآِْـِْ❉ِْـِْ,[ِْـِْئـِْ❉ِْـِْ,.,_",
									"❅ضـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅صـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅قـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅فـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅غـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅عـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅هـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅خـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅حـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅جـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅شـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅سـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅یـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅بـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅لـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅اؒؔ❢,❅نـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅تـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅مـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅چـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅ظـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅طـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅ـ۪۪ـؒؔـزؒؔـ۪۪ـؒؔـؒؔ❢,❅ـ۪۪ـؒؔـؒؔرـ۪۪ـؒؔـؒؔ❢,❅ـ۪۪ـؒؔـدؒؔـ۪۪ـؒؔـؒؔ❢,❅پـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅ـ۪۪ـؒؔـؒؔوـ۪۪ـؒؔـؒؔ❢,❅ڪـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅گـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅ثـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅ـ۪۪ـؒؔـژؒؔـ۪۪ـؒؔـؒؔ❢,❅ـ۪۪ـؒؔـذؒؔـ۪۪ـؒؔـؒؔ❢,❅۪۪آؒؔ❢,❅ئـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,.,_",
									}
				 result = {}
				i=0
				for k=1,#fonts_fa do
					i=i+1
					 tar_font = fonts_fa[i]:split(",")
					 text = WORD
					 text = text:gsub("ض",tar_font[1])
					 text = text:gsub("ص",tar_font[2])
					 text = text:gsub("ق",tar_font[3])
					 text = text:gsub("ف",tar_font[4])
					 text = text:gsub("غ",tar_font[5])
					 text = text:gsub("ع",tar_font[6])
					 text = text:gsub("ه",tar_font[7])
					 text = text:gsub("خ",tar_font[8])
					 text = text:gsub("ح",tar_font[9])
					 text = text:gsub("ج",tar_font[10])
					 text = text:gsub("ش",tar_font[11])
					 text = text:gsub("س",tar_font[12])
					 text = text:gsub("ی",tar_font[13])
					 text = text:gsub("ب",tar_font[14])
					 text = text:gsub("ل",tar_font[15])
					 text = text:gsub("ا",tar_font[16])
					 text = text:gsub("ن",tar_font[17])
					 text = text:gsub("ت",tar_font[18])
					 text = text:gsub("م",tar_font[19])
					 text = text:gsub("چ",tar_font[20])
					 text = text:gsub("ظ",tar_font[21])
					 text = text:gsub("ط",tar_font[22])
					 text = text:gsub("ز",tar_font[23])
					 text = text:gsub("ر",tar_font[24])
					 text = text:gsub("د",tar_font[25])
					 text = text:gsub("پ",tar_font[26])
					 text = text:gsub("و",tar_font[27])
					 text = text:gsub("ک",tar_font[28])
					 text = text:gsub("گ",tar_font[29])
					 text = text:gsub("ث",tar_font[30])
					 text = text:gsub("ژ",tar_font[31])
					 text = text:gsub("ذ",tar_font[32])
					 text = text:gsub("ئ",tar_font[33])
					 text = text:gsub("آ",tar_font[34])
					table.insert(result, text)
				end
				 result_text = "کلمه ی اولیه: "..WORD.."\nکلمه طراحی شده :\n"
				a=0
				for v=1,#result do
					a=a+1
					result_text = result_text..a.."- `"..result[a].."`\n\n"
				end
				tdbot.editMessageText(msg.chat_id, msg.id, nil, result_text, 1, false, nil, 'md')
				end
				end
				if Majhol_Self:match('^راهنما$') or Majhol_Self:match('^help$') then
					tdbot.deleteMessages(msg.chat_id, msg.id, true)
					---io.popen('cd Data && rm -rf HelpSelf.pdf && wget wget http://telepremium.ir/TelePremium/HelpSelf.pdf'):read('*a')
					tdbot.sendDocument(msg.chat_id, './HelpSelf.pdf', 'راهنمای سلف شما', nil, msg.id, 0, 1, nil, dl_cb, nil)
				end
			end
			end
		end
		end
	elseif data._ == 'updateNewMessage' then
		local msg = data.message
		if tostring(msg.chat_id):match('^-100') then
		ChatType = 'channel'
		elseif tostring(msg.chat_id):match('^-') then
		ChatType = 'chat'
		else
		ChatType = 'pv'
		end
		STRE = SemojeE[(math.random)(#SemojeE)]
			E = EemojeF[(math.random)(#EemojeF)]
			STR = SemojeF[(math.random)(#SemojeF)]
			J = Emoj[(math.random)(#Emoj)]
		redis:incr(Profile.."AllMsgChats")
		if redis:get(Profile..'SelfExpire') and redis:ttl(Profile..'SelfExpire') > 0 then
			days = math.ceil(redis:ttl(Profile..'SelfExpire')/86400)
			days = tonumber(days)
			if days <= 2 and not redis:get(Profile..'WarnExpire:') then
			redis:setex(Profile..'WarnExpire:', 46200, true)
			SendAlarm(msg,MasterId,STR..' از اعتبار سلف شما کمتر از 2 روز مانده است جهت تمدید به پیوی سازنده بروید')
			SendAlarm(msg,SudoId,STR..' انقضا سلف اکانت *'..Profile..'* کمتر از دو روز مانده است')
			end
		elseif not redis:get(Profile..'SelfExpire') and not redis:get(Profile..'SelfExpireEnd') then
			redis:set(Profile..'SelfExpireEnd',true)
				SendAlarm(msg,MasterId,STR..' اعتبار سلف شما به پایان رسید')
		end
		if redis:get(Profile..'SelfExpire') and not redis:get(Profile..'Self:') then
		if ChatType == 'pv' then
		if msg_valid(msg) then
			function Me(a, d)
				function CallBack(arg, data)
					text = redis:get(Profile..'SetMonshi') or false
					if text and not redis:get(Profile..'SendMonshiUser'..msg.chat_id) and data.status._ == 'userStatusOffline' then
						Mode = redis:get(Profile..'MonshiMode')
						if Mode == 'Voice' then
							tdbot.sendVoice(msg.chat_id, msg.id, redis:get(Profile..'MonshiFile'), nil, nil, (text or ''), nil, nil, nil, dl_cb, nil)
						else
							sendText(msg.chat_id, msg.id, UseMark(text)) 
						end
					redis:setex(Profile..'SendMonshiUser'..msg.chat_id, 1000, true)
					end
				end
				tdbot.getUser(d.id, CallBack)
			end
			tdbot.getMe(Me)
			if redis:get(Profile..'Enemy') and User_Enemy(msg) then
				Fosh = redis:smembers(Profile..'EnemyWord')
				sendText(msg.chat_id, msg.id, Fosh[math.random(#Fosh)])
			end
		end
		end
		if redis:get(Profile..'MarkReadChat'..msg.chat_id) then
			tdbot.openChat(msg.chat_id)
			tdbot.viewMessages(msg.chat_id, msg.id)
			tdbot.closeChat(msg.chat_id)
		elseif redis:get(Profile..'MarkReadChat') then
			if redis:get(Profile..'MarkReadChat') == 'All' then
				tdbot.openChat(msg.chat_id)
				tdbot.viewMessages(msg.chat_id, msg.id)
			elseif redis:get(Profile..'MarkReadChat') == 'Prvite' and ChatType == 'pv' then
				tdbot.openChat(msg.chat_id)
				tdbot.viewMessages(msg.chat_id, msg.id)
			elseif redis:get(Profile..'MarkReadChat') == 'Groups' and ChatType ~= 'pv' then
				tdbot.openChat(msg.chat_id)
				tdbot.viewMessages(msg.chat_id, msg.id)
			end
			tdbot.closeChat(msg.chat_id)
		end
		if ChatType ~= 'pv' then
		
			if redis:sismember(Profile..'SelfSilent'..msg.chat_id, msg.sender_user_id) then
				tdbot.deleteMessages(msg.chat_id, msg.id, true)
			end
			if redis:sismember(Profile..'SelfGpLock', msg.chat_id) then
				tdbot.deleteMessages(msg.chat_id, msg.id, true)
			end
			if msg.content._ == "messageChatAddMembers" then
				for i=0,#msg.content.member_user_ids do
					msg.add = msg.content.member_user_ids[i]
				end
			end
			if (msg.content._ == 'messageChatDeleteMember') and tonumber(msg.sender_user_id) == tonumber(MasterId) then
				redis:srem(Profile.."SuperGroup:", msg.chat_id)
				redis:srem(Profile.."Group:", msg.chat_id)
			end
			if redis:get(Profile..'Enemy') and User_Enemy(msg) and msg_valid(msg) then
				Fosh = redis:smembers(Profile..'EnemyWord')
				sendText(msg.chat_id, msg.id, Fosh[math.random(#Fosh)])
			end
		end
		end
		if msg.content._ == "messageText" then
			Our_Self = msg.content.text
			STRE = SemojeE[(math.random)(#SemojeE)]
			E = EemojeF[(math.random)(#EemojeF)]
			STR = SemojeF[(math.random)(#SemojeF)]
			J = Emoj[(math.random)(#Emoj)]
			if redis:get(Profile..'SelfExpire') and not redis:get(Profile..'Self:') then
			if not redis:get(Profile..'Answer:') then
				ReplyHash = redis:smembers(Profile.."SelfReply"..Our_Self:lower())
			  if #ReplyHash ~= 0 then
				function WhatISReply(msg)
				  test = {}
				  for k,v in pairs(ReplyHash) do
					table.insert(test, v)
				  end
				  return test
				end
				function GetFchat(arg, result)
					ChatName = result.title
					function GetUsername(a, r)
						if r.username ~= '' then
							UsrNm = '@'..r.username
						else
							UsrNm = 'نامشخص'
						end
						if r.first_name ~= '' then
							Fname = r.first_name
						else
							Fname = "نامشخص"
						end
				Days = os.date('%A')
				Days = string.gsub(Days,'Saturday','شنبه')
				Days = string.gsub(Days,'Sunday','یکشنبه')
				Days = string.gsub(Days,'Monday','دوشنبه')
				Days = string.gsub(Days,'Tuesday','سه شنبه')
				Days = string.gsub(Days,'Wednesday','چهارشنبه')
				Days = string.gsub(Days,'Thursday','پنجشنبه')
				Days = string.gsub(Days,'Friday','جمعه')
				ping = (io.popen('ping -c 1 api.telegram.org'):read('*a')):match('time=(%S+)')
				math.randomseed(os.time())
				if #WhatISReply(msg) <= 0 then
				return
				end
				Rando = WhatISReply(msg)[math.random(#WhatISReply(msg))]
				Rando = Rando:gsub('code','`')
				Rando = Rando:gsub('bold','*')
				Rando = Rando:gsub('gp',UseMark(ChatName))
				Rando = Rando:gsub('name',UseMark(Fname))
				Rando = Rando:gsub('user',UseMark(UsrNm))
				Rando = Rando:gsub('Hor',os.date('%H'))
				Rando = Rando:gsub('Min',os.date('%M'))
				Rando = Rando:gsub('Sec',os.date('%S'))
				Rando = Rando:gsub('day',Days) 
				Rando = Rando:gsub('ping',ping) 
				sendText(msg.chat_id, msg.id, tostring(Rando))
					end
					tdbot.getUser(msg.sender_user_id, GetUsername)
				end
				tdbot.getChat(msg.chat_id,GetFchat)
			  end
			end
		end
		if (Our_Self:match('^اعتبار (%d+)$') or Our_Self:match('^expire (%d+)$')) and msg.sender_user_id == SudoId then
			Expire = tonumber(msg.content.text:match('(%d+)$')) * 86400
			Time = math.floor(Expire / 86400 )
			redis:setex(Profile..'SelfExpire',Expire,true)
			redis:del(Profile..'SelfExpireEnd')
			sendText(msg.chat_id, msg.id, STR..' شارژ اکانت *'..Profile..'* به `'..Time..'` روز تنظیم شد')
		end
		if (Our_Self:match('^+اعتبار (%d+)$') or Our_Self:match('^+expire (%d+)$')) and msg.sender_user_id == SudoId then
			Expire = tonumber(msg.content.text:match('(%d+)$')) * 86400
			OldTime = redis:ttl(Profile..'SelfExpire')
			TimeOld = math.floor(OldTime / 86400 )
			NewTime = math.floor(Expire / 86400 )
			TimeNew = math.floor((Expire + OldTime) / 86400 )
			redis:setex(Profile..'SelfExpire',Expire + OldTime,true)
			sendText(msg.chat_id, msg.id, STR..' انقضا سلف اکانت *'..Profile..'* تغییر کرد به '..TimeNew..' روز مقدار شارژ اضافه شده '..NewTime..' روز شارژ قبلی '..TimeOld..' روز')
		end
	end
	end
	if not redis:get(Profile..'autoCleanCash') then
		redis:setex(Profile..'autoCleanCash', 1800, true)
		runRequest('rm ~/.telegram-bot/*/data/stickers/*')
		runRequest('rm ~/.telegram-bot/*/data/thumbnails/*')
		runRequest('rm ~/.telegram-bot/*/files/*/*')
  end
end