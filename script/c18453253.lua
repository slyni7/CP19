--트라이앵글러 스퀘어드
local m=18453253
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	aux.AddEquationProcedure(c,aux.ProcFitSquare(cm),cm.pfun1,1,1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STf")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetLabelObject(e2)
	e2:SetLabelObject(e1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","M")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCL(1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
cm.square_mana={0x0}
cm.custom_type=CUSTOMTYPE_SQUARE+CUSTOMTYPE_EQUATION
function cm.pfun1(...)
	local t={...}
	if not t[1] then
		return 0
	end
	local i=1
	while true do
		if (t[1]-i)^2+(t[2]-i)^2-i^2==0 then
			return 0
		end
		if i*(1-2^(-1/2))>t[1] and i*(1-2^(-1/2))>t[2] then
			break
		end
		i=i+1
	end
	return false
end
function cm.val1(e,c)
	local g=c:GetMaterial()
	if #g~=2 then
		return
	end
	local te=e:GetLabelObject()
	e:SetLabel(0)
	te:SetLabel(0)
	local tc=g:GetFirst()
	local nc=g:GetNext()
	local v1=tc:GetLevel()
	local v2=nc:GetLevel()
	local i=1
	while true do
		if (v1-i)^2+(v2-i)^2-i^2==0 then
			if e:GetLabel()==0 then
				e:SetLabel(i)
			else
				te:SetLabel(i)
			end
		end
		if i*(1-2^(-1/2))>v1 and i*(1-2^(-1/2))>v2 then
			break
		end
		i=i+1
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_EQUATION)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local te=e:GetLabelObject()
	local v1=e:GetLabel()
	local v2=te:GetLabel()
	local t={}
	if v1>0 then
		table.insert(t,v1)
	end
	if v2>0 then
		table.insert(t,v2)
	end
	if #t>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local ac=Duel.AnnounceNumber(tp,table.unpack(t))
		e:SetLabel(ac)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local v=e:GetLabel()
	if v==0 then
		return
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(v)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e2:SetValue(v*300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	e3:SetValue(v*200)
	c:RegisterEffect(e3)
end
function cm.tfil3(c)
	return (c:IsSetCard(0xe85) or c:IsSetCard(0xe86) or c:IsSetCard(0xe87) or c:IsSetCard(0x2d7))
		and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end