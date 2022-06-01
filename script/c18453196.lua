--Arom@$er@phy - J@$mine
local m=18453196
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FBF(Card.IsLinkSetCard,0x2e6),2,2)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")	
	e2:SetCode(EFFECT_CHANGE_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,0)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S")
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(cm.con4)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"F","M")
	e5:SetCode(EFFECT_REVERSE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTR(1,0)
	e5:SetValue(cm.val5)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"F","M")
	e6:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e6:SetTR("M","M")
	e6:SetCondition(cm.con6)
	e6:SetTarget(cm.tar6)
	e6:SetValue(aux.imval1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetValue(aux.tgoval)
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"I","M")
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetD(m,0)
	e8:SetCL(1)
	WriteEff(e8,8,"CTO")
	c:RegisterEffect(e8)
	local e9=MakeEff(c,"I","M")
	e9:SetCategory(CATEGORY_RECOVER)
	e9:SetD(m,1)
	e9:SetCL(1)
	WriteEff(e9,9,"CTO")
	c:RegisterEffect(e9)
	local e10=MakeEff(c,"FC","M")
	e10:SetCode(EVENT_RECOVER)
	WriteEff(e10,10,"O")
	c:RegisterEffect(e10)
end
function cm.con1(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.val2(e,re,rec,r,rp)
	local tp=e:GetHandlerPlayer()
	if not GlobalAromaRecover[tp] then
		GlobalAromaRecover[tp]=true
		return rec*10
	end
	return rec
end
function cm.val3(e,re)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return c~=rc and (re:IsHasCategory(CATEGORY_RECOVER) or (re:IsActiveType(TYPE_MONSTER) and c:GetAttribute()&rc:GetAttribute()>0))
end
function cm.con4(e)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	return c==a
end
function cm.val5(e,re,r,rp,rc)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	return c==a and r&REASON_BATTLE>0
end
function cm.con6(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(1-tp)>0 and math.floor(Duel.GetLP(tp)/Duel.GetLP(1-tp))>=2
end
function cm.tar6(e,c)
	local h=e:GetHandler()
	local g=h:GetLinkedGroup()
	return c:IsSetCard(0x2e6) and (h==c or g:IsContains(c))
end
function cm.cfil8(c,g,tp)
	return g:IsContains(c) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.cost8(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,cm.cfil8,1,nil,lg,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,cm.cfil8,1,1,nil,lg,tp)
	Duel.Release(g,REASON_COST)
end
function cm.tfil8(c,e,tp)
	return c:IsSetCard(0x2e6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tar8(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil8,tp,"D",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op8(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil8,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function cm.cfil9(c,g)
	local val=c:GetLevel()+c:GetRank()+c:GetLink()
	return g:IsContains(c) and val>0
end
function cm.cost9(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,cm.cfil9,1,nil,lg)
	end
	local g=Duel.SelectReleaseGroup(tp,cm.cfil9,1,1,nil,lg)
	local tc=g:GetFirst()
	local val=(tc:GetLevel()+tc:GetRank()+tc:GetLink())*100
	Duel.Release(g,REASON_COST)
	e:SetLabel(val)
end
function cm.tar9(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local rec=e:GetLabel()
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function cm.op9(e,tp,eg,ep,ev,re,r,rp)
	local rec=e:GetLabel()
	Duel.Recover(tp,rec,REASON_EFFECT)
end
function cm.ofil10(c)
	return c:IsSetCard(0x2e6) and c:IsAbleToHand()
end
function cm.op10(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=true
	for _,flag in ipairs({c:GetFlagEffectLabel(m)}) do
		if flag==1 then
			b1=false
		end
		if flag==2 then
			b2=false
		end
	end
	local g1=Duel.GMGroup(cm.ofil10,tp,"D",0,nil,1)
	if b1 and #g1>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1,1)
	end
	local dct=math.floor(Duel.GetLP(tp)/Duel.GetLP(1-tp))
	if b2 and Duel.GetLP(1-tp)>0 and dct>=1 and Duel.IsPlayerCanDraw(tp,1) then
		local t={}
		for i=1,dct do
			if Duel.IsPlayerCanDraw(tp,i) then
				table.insert(t,i)
			end
		end
		local ac=0
		if #t==1 then
			ac=t[1]
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			ac=Duel.AnnounceNumber(tp,table.unpack(t))
		end
		local dct=Duel.Draw(tp,ac,REASON_EFFECT)
		c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1,2)
	end
end