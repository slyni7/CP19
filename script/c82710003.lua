--아르카나 포스 VIII-스트렝스
function c82710003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_COIN+CATEGORY_CONTROL)
	e1:SetTarget(c82710003.tar1)	
	e1:SetOperation(c82710003.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCondition(c82710003.con4)
	c:RegisterEffect(e4)
end
c82710003.toss_coin=true
function c82710003.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c82710003.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else
		res=Duel.TossCoin(tp,1)
	end
	c82710003.arcanareg(c,res)
	if res==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.GetControl(tc,tp)
		end
	else
		local g=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,c)
		while g:GetCount()>0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			local tg=g:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			Duel.GetControl(tc,1-tp)
			g:Sub(tg)
		end
	end
end
function c82710003.arcanareg(c,coin)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c82710003.con4(e,c,minc)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return minc==0 and c:IsLevelAbove(5) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE)<1
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end